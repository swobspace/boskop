class SoftwareRawData::ImportCsvJob < ApplicationJob
  queue_as :default

  # SoftwareRawData::ImportCsv.perform(options)
  # mandantory:
  # * :file - tempfile from upload
  # * :source - String; i.e. 'docusnap'
  # optional:
  # * :lastseen - date
  #
  def perform(options = {})
    @options = options.symbolize_keys!
    file        = options.fetch(:file)   { raise ArgumentError, "missing option :file" }
    source      = options.fetch(:source) { raise ArgumentError, "missing option :source" }
    lastseen    = options.fetch(:lastseen) { nil }
    recent_only = options.fetch(:recent_only) { false }

    result = SoftwareRawData::ImportCsvService.new(file: file, source: source, 
             recent_only: recent_only, lastseen: lastseen).call
    if result.success?
      logger.info "Import successful; #{result.software_raw_data.count} records imported"
    else
      logger.warn("### WARNING ###: import failure: #{result.errors.inspect}")
    end
  end

private

  def logger
    @logger ||= Logger.new(File.join(Rails.root, 'log', "software_raw_data_import_csv_#{Rails.env}.log"))
  end
end
