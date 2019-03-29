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
    def initialize(options = {})
      @options = options.symbolize_keys
      @mode    = options.fetch(:mode, :newer)
      @host_attributes ||= host_attributes
      @if_attributes   ||= if_attributes
      @host    ||= initialize_host
    end

    def save
      if @host.nil?
        @host = Host.create(host_attributes.merge(network_interface_attributes: if_attributes)
      else
        # update attributes if @host.persisted?
        @host.update_attributes(host_updates) &&
          NetworkInterface.create_with(if_attributes)
                          .create_or_find_by(host_id: host.id, ip: ip)
      end
    end

  private
    attr_reader :options, :mode
    def initialize_host
      if on_blacklist?(:uuid)
        host = Host.where(uuid: uuid, name: name).order("lastseen desc").first
      if on_blacklist?(:serial)
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


    def host_attributes
      options.fetch(:attributes).reject do |k,v|
        !(Host.attribute_names.include?(k.to_s))
      end
    end
    
    def host_updates
      # FIXME
      host_attributes
    end

    def if_attributes
      options.fetch(:attributes).reject do |k,v|
        # !(NetworkInterface.attribute_names.include?(k.to_s))
      end
    end

    def on_blacklist?(attr)
      Boskop.send("#{attr}_blacklist").include?(attr)
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

    def ip
      if_attributes[:ip]
    end
  end
end
