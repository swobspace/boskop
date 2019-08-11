class Nessus::ImportScansJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    options.symbolize_keys!
    @import_mode = options.fetch(:import_mode, 'auto')
    @nessus_id = options.fetch(:nessus_id, nil)
    return unless pending_scans.any?
    pending_scans.each do |scan|
      dlresult = DownloadNessusScanService.new(nessus_id: scan.nessus_id).call
      if dlresult.success?
        Rails.logger.info("### Nessus XML #{dlresult.xmlfile} #{scan.name} " +
                          "successfull downloaded")
        imresult = ImportNessusVulnerabilitiesService.new(file: dlresult.xmlfile, level: :all).call
        if imresult.success?
          Rails.logger.info("### Nessus Scan #{scan.name} successfully imported")
          scan.update_attributes(import_state: 'done')
        else
          Rails.logger.warn(
            "### Import Nessus Scan #{scan.name} failed for some reason: " +
            "#{imresult.error_message}"
          )
          scan.update_attributes(import_state: 'failed')
        end
      else
        Rails.logger.warn("### Could not download Nessus XML #{dlresult.xmlfile}: " +
                          "#{dlresult.error_message} (#{scan.name}")
        scan.update_attributes(import_state: 'failed')
      end
    end
    UpdateVulnRiskJob.perform_now
  end

private

  attr_reader :import_mode, :nessus_id

  def pending_scans
    if nessus_id
      importable_scans = NessusScan.where(nessus_id: nessus_id).limit(1)
    else
      importable_scans = NessusScan.where(import_state: 'new', status: 'completed',
                                          import_mode: import_mode)
    end
    if importable_scans.any?
      Rails.logger.info("### Starting import on #{importable_scans.count} scan(s)")
    else
      Rails.logger.info("### No pending scans, nothing to import")
    end
     importable_scans
  end
end
