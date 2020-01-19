module Vulnerabilities
  # 
  # Vulnerabilities::Creator
  # create vulnerabilities via attributes taken from nessus, nmap, csv, etc.
  #
  class Creator
    attr_reader :vulnerability
    #
    # Vulnerabilities::Creator.new(mode: :newer, attributes: {some attribs})
    # 
    # mandantory options:
    # * attributes: hash of vulnerability attributes
    #
    # optional options:
    # * mode: [:newer, :always]
    #
    def initialize(options = {})
      @options       = options.symbolize_keys
      @mode          = fetch_mode
      @vulnerability ||= fetch_vulnerability
      @old_lastseen  = @vulnerability&.lastseen || '1970-01-01'.to_date
      @debug         = options.fetch(:debug, false)
    end

    def save
      if @vulnerability.nil?
        @vulnerability = Vulnerability.new(vulnerability_attributes)
        @vulnerability.save
      else
        # update attributes if @vulnerability.persisted?
        @vulnerability.update(vulnerability_updates)
      end
    end

  private
    attr_reader :options, :mode, :old_lastseen, :debug

    def fetch_vulnerability
      Vulnerability.where(host_id: host_id, vulnerability_detail_id: vulnerability_detail_id).first
    end

    # fetch_attributes and cleanup
    # symbolize all attribute keys
    # * remove prefix or suffixes
    # * search for matching objects in relations if attribute =~ /_id\z/
    #
    def fetch_attributes
      attributes = options.fetch(:attributes).symbolize_keys
    end

    def fetch_mode
      mode = options.fetch(:mode, :newer).to_sym
      unless [:newer, :always, :none].include?(mode)
        raise ArgumentError, "vulnerability updates with mode #{mode} is not implemented"
      end
      mode
    end

    def vulnerability_attributes
      @vulnerability_attributes ||= fetch_attributes.reject do |k,v|
        !(Vulnerability.attribute_names.include?(k.to_s)) || v.blank?
      end
    end
    
    def vulnerability_updates
      update_seen = (old_lastseen <= lastseen) ? {lastseen: lastseen} : {}
      case mode
      when :none
        update_seen
      when :newer
        ( old_lastseen <= lastseen ) ? vulnerability_attributes : {}
      when :always
        vulnerability_attributes
      else
        raise ArgumentError, "vulnerability updates with mode #{mode} is not implemented"
      end
    end

    def host_id
      vulnerability_attributes[:host_id]
    end

    def vulnerability_detail_id
      vulnerability_attributes[:vulnerability_detail_id]
    end

    def lastseen
      vulnerability_attributes[:lastseen].to_date
    end
  end
end
