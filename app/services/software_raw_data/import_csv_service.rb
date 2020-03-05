require 'csv'
module SoftwareRawData
  #
  # import csv data
  #
  class ImportCsvService
    Result = ImmutableStruct.new( :success?, :error_message, :software_raw_data )
    
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
      update_csv_converters
    end

    # service.call()
    #
    def call
      software_raw_data = []
      errors = []
      success = true
      unless File.readable?(csvfile)
        message = "File #{csvfile} is not readable or does not exist"
        return Result.new(
                 success: false, 
                 error_message: message, 
                 software_raw_data: software_raw_data
               )
      end
      CSV.foreach(csvfile, headers: true, col_sep: ';',
                           header_converters: header_converters(source),
                           converters: :date) do |row|
        attributes = row.to_hash
        attributes["lastseen"] ||= lastseen
        attributes["source"] ||= source
        sc = SoftwareRawData::Creator.new(attributes: attributes)
        if sc.save
           software_raw_data << sc.software_raw_datum
        else
          if software_raw_data.errors.any?
           errors << "#{software_raw_data.errors.full_messages.join(', ')}" 
          end
          success = false
        end
      end
      return_result = Result.new(
                        success: success, 
                        error_message: errors, 
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
        "Betriebssystem" => "operating_system"
      }
    end

    def header_converters(source)
      if source.to_sym == :docusnap
        :docusnap
      else
        nil
      end
      
    end
  end # class ImportCsvService
end # module SoftwareRawData

