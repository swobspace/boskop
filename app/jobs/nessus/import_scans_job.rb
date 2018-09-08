class Nessus::ImportScansJob < ApplicationJob
  queue_as :default

  def perform(*args)
    pending_scans.each do |scan|
      dlresult = DownloadNessusScanService.new(nessus_id: scan.nessus_id).call
      imresult = ImportNessusVulnerabilitiesService.new(file: dlresult.xmlfile).call
      if imresult.success?
        scan.update_attributes(import_state: 'done')
      else
        scan.update_attributes(import_state: 'failed')
      end
    end
  end

private
  def pending_scans
    NessusScan.where(import_state: 'new').limit(1)
  end
end
