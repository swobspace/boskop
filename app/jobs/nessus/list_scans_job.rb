require 'tenable-ruby'


class Nessus::ListScansJob < ApplicationJob
  queue_as :default

  # Import current list from Nessus by nessus_id
  # this means no history, only the last scan will be fetched
  # reset import_state to new if uuid has changed since last fetch
  #
  def perform(*args)
    nessus = TenableRuby::Client.new(
               credentials: {
                 access_key: Rails.application.secrets.nessus_access_key,
                 secret_key: Rails.application.secrets.nessus_secret_key
               },
               url: Boskop.nessus_url
             )
    if nessus.authenticate
      scan_list = nessus.scan_list
      scan_list['scans'].each do |scan|
        next if scan['uuid'].blank?
        nscan = NessusScan.find_or_initialize_by(nessus_id: scan['id'])
        nscan.name      = scan['name']
        unless nscan.uuid == scan['uuid']
          nscan.uuid         = scan['uuid']
          nscan.import_state = 'new'
        end
        nscan.status    = scan['status']
        nscan.last_modification_date = Time.at(scan['last_modification_date'].to_i)
        nscan.save!
      end
    else
      raise RuntimeError, "could not authenticate, no scans listed"
    end
  end
end
