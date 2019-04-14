module Hosts
  # 
  # Hosts::Creator
  # create hosts via attributes taken from nessus, nmap, csv, etc.
  #
  class Creator
    attr_reader :host
    #
    # Hosts::Creator.new(mode: :newer, attributes: {some attribs})
    # 
    # mandantory options:
    # * attributes: hash of host and network_interface attributes
    #
    # optional options:
    # * mode: [:newer, :missing, :always]
    #
    def initialize(options = {})
      @options = options.symbolize_keys
      @mode    = fetch_mode
      @host_attributes ||= host_attributes
      @if_attributes   ||= if_attributes
      @host    ||= fetch_host
      @old_lastseen = @host&.lastseen
      @debug = options.fetch(:debug, false)
    end

    def save
      if @host.nil?
        @host = Host.create(create_attributes)
        @host.valid?
      else
        if debug
          puts NetworkInterface.where(host_id: host.id, ip: if_attributes[:ip]).inspect
          puts "#{host.id}, #{if_attributes[:ip]}"
        end
        # update attributes if @host.persisted?
        @host.update_attributes(host_updates) &&
          !!(NetworkInterface.create_with(if_attributes.except(:host_id, :ip))
                          .find_or_create_by(host_id: host.id, ip: if_attributes[:ip]))
      end
    end

  private
    attr_reader :options, :mode, :old_lastseen, :debug
    def fetch_host
      if on_blacklist?(:uuid)
        host = Host.where(uuid: uuid, name: name).order("lastseen desc").first
      elsif on_blacklist?(:serial)
        host = Host.where(serial: serial, name: name).order("lastseen desc").first
      elsif uuid.present?
        host = Host.where(uuid: uuid).order("lastseen desc").first
      elsif serial.present?
        host = Host.where(serial: serial).order("lastseen desc").first
      else
        # use ip as fallback
        host = NetworkInterface.where(ip: ip).order("lastseen desc").first&.host
      end
    end

    def fetch_mode
      mode = options.fetch(:mode, :newer)
      unless [:newer, :missing, :always, :none].include?(mode)
        raise ArgumentError, "host updates with mode #{mode} is not implemented"
      end
      mode
    end

    def create_attributes
      if if_attributes[:ip].blank?
        host_attributes
      else
        host_attributes.merge(network_interfaces_attributes: [ if_attributes ])
      end
    end

    def host_attributes
      options.fetch(:attributes).reject do |k,v|
        !(Host.attribute_names.include?(k.to_s))
      end
    end
    
    def host_updates
      case mode
      when :none
        {}
      when :newer
        ( old_lastseen <= lastseen ) ? host_attributes : {}
      when :missing
        host_attributes.select {|k,v| host.send(k).blank?}.merge(lastseen: lastseen)
      when :always
        host_attributes
      else
        raise ArgumentError, "host updates with mode #{mode} is not implemented"
      end
    end

    def if_attributes
      options.fetch(:attributes).reject do |k,v|
        !(NetworkInterface.attribute_names.include?(k.to_s))
      end
    end

    def on_blacklist?(attr)
      Boskop.send("#{attr}_blacklist").include?(host_attributes[attr])
    end

    def uuid
      host_attributes[:uuid]
    end

    def serial
      host_attributes[:serial]
    end

    def name
      host_attributes[:name]
    end

    def lastseen
      host_attributes[:lastseen].to_date
    end

    def ip
      if_attributes[:ip]
    end
  end
end
