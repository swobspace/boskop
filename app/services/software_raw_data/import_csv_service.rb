require 'csv'
module SoftwareRawData
  #
  # import csv data
  #
  class ImportCsvService
    Result = ImmutableStruct.new( :success?, :errors, :error_message, :software_raw_data )
    
    # service = SoftwareRawData::ImportCsvService.new(
    #             file: 'csvfile', source: 'docusnap', lastseen: '2020-02-29'
    #            )
    # mandatory options:
    # * :file   - csv import file
    #
    # optional parameters:
    # * :lastseen - global default if entry from csv is missing
    # * :source   - global default if entry from csv is missing
    #
    def initialize(options = {})
      options.symbolize_keys!
      @csvfile  = get_file(options)
      @lastseen = options.fetch(:lastseen) { Date.today.to_s }
      @source   = options.fetch(:source)   { "" }
      @recent_only = options.fetch(:recent_only) { false }
      update_csv_converters
    end

    # service.call()
    #
    def call
      software_raw_data = []
      errors = []
      error_messages = []
      success = true
      unless File.readable?(csvfile)
        message = "File #{csvfile} is not readable or does not exist"
        return Result.new(
                 success: false, 
                 errors: errors,
                 error_message: message, 
                 software_raw_data: software_raw_data
               )
      end
      CSV.foreach(csvfile, headers: true, col_sep: ';',
                           header_converters: header_converters(source),
                           nil_value: "",
                           liberal_parsing: true,
                           converters: :date) do |row|
        attributes = row.to_hash
        attributes["lastseen"] = normalize_date(attributes["lastseen"])
        attributes["lastseen"] = lastseen if attributes["lastseen"].blank?
        attributes["source"] = source if attributes["source"].blank?

        if (recent_only? && !(is_recent?(attributes["lastseen"])))
          next
        end

        sc = SoftwareRawData::Creator.new(attributes: attributes)
        if sc.save
           swr = sc.software_raw_datum
           software_raw_data << swr
           update_installed_software(swr, attributes)
        else
          if sc.software_raw_datum.errors.any?
           error_messages << "#{sc.software_raw_datum.errors.full_messages.join(", ")}"
           errors << sc.software_raw_datum.errors
          end
          success = false
        end
      end
      return_result = Result.new(
                        success: success, 
                        error_message: error_messages.join("; "), 
                        errors: errors, 
                        software_raw_data: software_raw_data
                      )
    end

  private
    attr_reader :csvfile, :lastseen, :source

    # file may be ActionDispatch::Http::UploadedFile
    #
    def get_file(options)
      file = options.fetch(:file)
      if file.respond_to?(:path)
        file.path
      else
        file.to_s
      end
    end

    def update_csv_converters
      CSV::HeaderConverters[:docusnap] = ->(v) { docusnap_headers[v] || v }
    end

    def docusnap_headers
      { 
        "Name" => "name",
        "Version" => "version",
        "Hersteller" => "vendor",
        "Anzahl" => "count",
        "Betriebssystem" => "operating_system",
        "software_name" => "name",
        "software_version" => "version",
        "software_vendor" => "vendor",
        "software_operating_system" => "operating_system",
      }
    end

    def header_converters(source)
      if source.to_sym == :docusnap
        :docusnap
      else
        nil
      end
    end

    def update_installed_software(swr, attributes)
      host_attributes = attributes.select {|k,v| k =~ /\Ahost_/}
      host_attributes.transform_keys!{|k| k[5..-1]}
      host = Hosts::Creator.new(attributes: host_attributes).host
      unless (swr.nil? || host.nil?)
        isw = InstalledSoftware
              .create_with(lastseen: attributes["lastseen"])
              .find_or_create_by!(software_raw_datum_id: swr.id, host_id: host.id)
        if isw.lastseen.to_s < attributes["lastseen"].to_s
          isw.update(lastseen: attributes["lastseen"].to_s)
        end
      end
    end

    def recent_only?
      !!@recent_only
    end

    def normalize_date(date)
      if date.kind_of? Date
        date
      else
        begin
          Date.parse(date.to_s)
        rescue ArgumentError
          nil
        end
      end
    end

    def is_recent?(date)
      date = normalize_date(date)
      date.present? && (date.to_s >= 1.month.before(Date.today).to_s)
    end

  end # class ImportCsvService
end # module SoftwareRawData

