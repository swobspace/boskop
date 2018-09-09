class Nessus::ImportScansJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    options.symbolize_keys!
    @import_mode = options.fetch(:import_mode, 'auto')
    pending_scans.each do |scan|
      dlresult = DownloadNessusScanService.new(nessus_id: scan.nessus_id).call
      if dlresult.success?
        Rails.logger.info("Nessus XML #{dlresult.xmlfile} successfull downloaded")
        imresult = ImportNessusVulnerabilitiesService.new(file: dlresult.xmlfile).call
        if imresult.success?
          Rails.logger.info("Nessus Scan successfully imported")
          scan.update_attributes(import_state: 'done')
        else
        Rails.logger.warn("Import Nessus Scans failed for some reason: " +
                          "#{imresult.error_message}")
          scan.update_attributes(import_state: 'failed')
        end
      else
        Rails.logger.warn("Could not download Nessus XML file #{dlresult.xmlfile}: " +
                          "#{dlresult.error_message}")
        scan.update_attributes(import_state: 'failed')
      end
    end
  end

private
  attr_reader :import_mode
  def pending_scans
    importable_scans = NessusScan.where(import_state: 'new', status: 'completed',
                                        import_mode: import_mode)
    if importable_scans.any?
      Rails.logger.info("Starting import on #{importable_scans.count} scan(s)")
    else
      Rails.logger.info("No pending scans, nothing to import")
    end
     importable_scans
  end
end
