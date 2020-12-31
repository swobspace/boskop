module SoftwareRawData
  # 
  # SoftwareRawData::Creator
  # create hosts via attributes taken from nessus, nmap, csv, etc.
  #
  class Creator
    attr_reader :software_raw_datum, :attributes
    CREATE_ATTRIBUTES = [:name, :vendor, :version, :operating_system]

    # SoftwareRawData::Creator.new(attributes: {some attribs})
    # 
    # mandantory options:
    # * attributes: hash of raw data attributes
    #
    # optional options:
    #
    def initialize(options = {})
      @options = options.symbolize_keys
      @attributes = fetch_attributes
      @software_raw_datum ||= fetch_software_raw_datum
      @old_lastseen = @software_raw_datum&.lastseen || '1970-01-01'.to_date
      @debug = options.fetch(:debug, false)
    end

    def save
      return false if lastseen.nil?
      if @software_raw_datum.nil?
        @software_raw_datum = SoftwareRawDatum.new(create_attributes.merge(upd_attributes))
        status = @software_raw_datum.save
      elsif old_lastseen.to_s <= lastseen.to_s
        # update attributes if @software_raw_datum.persisted?
        status = @software_raw_datum.update(upd_attributes)
      else
        true
      end
    end

  private
    attr_reader :options, :old_lastseen, :debug

    def fetch_software_raw_datum
      software_raw_datum = SoftwareRawDatum.where(create_attributes).first 
    end

    # fetch_attributes and symbolize
    def fetch_attributes
      attribs = options.fetch(:attributes).symbolize_keys
      unless attribs.key?(:name) && attribs.key?(:vendor) && attribs.key?(:version)
        raise ArgumentError, ":name, :vendor or :version option is missing"
      end
      attribs.reject do |k,v|
        !(SoftwareRawDatum.attribute_names.include?(k.to_s)) || 
          [:id, :created_at, :updated_at].include?(v)
      end
    end

    def create_attributes
      attributes.slice(*CREATE_ATTRIBUTES)
    end

    def upd_attributes
      attributes.except(*CREATE_ATTRIBUTES)
    end

    def lastseen
      if attributes[:lastseen].kind_of? Date
        attributes[:lastseen]
      else
        begin
          Date.parse(attributes[:lastseen].to_s)
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
