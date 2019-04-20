module Hosts
  # 
  # Hosts::Creator
  # create hosts via attributes taken from nessus, nmap, csv, etc.
  #
  class Creator
    attr_reader :host, :iface
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
      @host    ||= fetch_host
      @old_lastseen = @host&.lastseen || '1970-01-01'.to_date
      @debug = options.fetch(:debug, false)
    end

    def save
      if @host.nil?
        @host = Host.new(create_attributes)
        status = @host.save
      else
        # update attributes if @host.persisted?
        status = @host.update_attributes(host_updates) && save_iface
      end
      save_location
      status
    end

    def save_iface
      @iface = fetch_iface
      return true if if_attributes[:ip].blank?
      if @iface.nil?
        @iface = NetworkInterface.new(if_attributes.merge(host_id: host.id))
        @iface.save!
      else
        @iface.update_attributes(if_updates)
      end
    end

    def save_location
      if @host.location.nil?
        @host.set_location.save
      else
        true
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

    def fetch_iface
      if host.nil? || if_attributes[:ip].blank?
        return nil
      end
      if if_attributes[:mac].present?
        ifaces = NetworkInterface.where(host_id: host.id, ip: if_attributes[:ip], 
                                        mac: if_attributes[:mac])
      else
        ifaces = NetworkInterface.where(host_id: host.id, ip: if_attributes[:ip])
      end
      ifaces.order("lastseen desc").first
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
        !(Host.attribute_names.include?(k.to_s)) || v.blank?
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
        !(NetworkInterface.attribute_names.include?(k.to_s)) || v.blank?
      end
    end

    def if_updates
      if old_lastseen <= lastseen
        if_attributes.reject do |k,v|
          [:ip, :host_id].include?(k) || v.blank?
        end
      else
        # old data, update missing only
        if_attributes.select {|k,v| iface.send(k).blank?}
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
