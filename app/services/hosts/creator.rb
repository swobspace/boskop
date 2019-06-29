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
        status = @host.save && update_merkmale
      else
        # update attributes if @host.persisted?
        status = @host.update_attributes(host_updates) && update_merkmale && save_iface
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
      if ip.blank?
        return nil
      end
      if mac.present?
        ifaces = NetworkInterface.where(host_id: host.id, ip: ip, mac: mac)
      else
        ifaces = NetworkInterface.where(host_id: host.id, ip: ip)
      end
      ifaces.order("lastseen desc").first
    end

    # fetch_attributes and cleanup
    # symbolize all attribute keys
    # * remove prefix or suffixes
    # * search for matching objects in relations if attribute =~ /_id\z/
    #
    def fetch_attributes
      attributes = options.fetch(:attributes).symbolize_keys
      attributes[:cpe].to_s.sub!(/cpe:/, '')
      attributes.keys.grep(/_id\z/).map(&:to_sym).each do |attr|
        attributes[attr] = search_for_id(attributes, attr)
      end
      attributes
    end

    def search_for_id(attributes, key)
      myklass = key.to_s.sub(/_id\z/,'').camelize.constantize
      value   = attributes.fetch(key, nil)
      return nil unless value.present?
      # search for id
      if value.to_i > 0
        myklass.where(id: value).first&.id
      # search for field with exact string value match
      elsif value.kind_of? String
        search_string = []
        ['tag', 'name', 'lid'].each do |attr|
          if myklass.attribute_names.include?(attr)
            search_string << "#{attr} ILIKE :search"
          end
        end
        myklass.where(search_string.join(' or '), search: "#{value}").first&.id
      else
        nil
      end
    end

    def fetch_mode
      mode = options.fetch(:mode, :newer).to_sym
      unless [:newer, :missing, :always, :none].include?(mode)
        raise ArgumentError, "host updates with mode #{mode} is not implemented"
      end
      mode
    end

    def create_attributes
      if ip.blank?
        host_attributes
      else
        host_attributes.merge(network_interfaces_attributes: [ if_attributes ])
      end
    end

    def host_attributes
      @host_attributes ||= fetch_attributes.reject do |k,v|
        !(Host.attribute_names.include?(k.to_s)) || v.blank?
      end
    end
    
    def host_updates
      update_seen = (old_lastseen <= lastseen) ? {lastseen: lastseen} : {}
      case mode
      when :none
        update_seen
      when :newer
        ( old_lastseen <= lastseen ) ? host_attributes : {}
      when :missing
        if 4.weeks.after(lastseen) > old_lastseen
          host_attributes.select {|k,v| host.send(k).blank?}.merge(update_seen)
        else
          {}
        end
      when :always
        host_attributes
      else
        raise ArgumentError, "host updates with mode #{mode} is not implemented"
      end
    end

    def if_attributes
      @if_attributes ||= fetch_attributes.reject do |k,v|
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

    def update_merkmale
      fetch_attributes.slice(*merkmal_attributes).each do |key,val|
        if mode == :always || 
          (mode == :newer && old_lastseen <= lastseen) || 
          (mode == :missing && host.send(key).blank?)
            host.send("#{key}=", val)
        end
      end
    end

    def merkmal_attributes
      Merkmalklasse.where(for_object: 'Host').pluck(:tag).map {|t| "merkmal_#{t}".to_sym }
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

    def mac
      if if_attributes[:mac].present?
        if_attributes[:mac].upcase.gsub(/[^0-9A-F\n]/, '').split(/\n/).first
      end
    end
  end
end
