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
      scan_list = nessus.scan_list['scans']
      if scan_list.blank?
         Rails.logger.warn "### Authenticate succeeded, but no data; check network, proxy settings and firewall"
      else
	scan_list.each do |scan|
	  next if scan['uuid'].blank?	# no scan available
	  next if scan['name'] =~ /test/i # ignore test scans
	  nscan = NessusScan.find_or_initialize_by(nessus_id: scan['id'])
	  if nscan.import_mode.blank?
	    nscan.import_mode = 'unassigned'
	  end
	  nscan.name      = scan['name']
	  unless nscan.uuid == scan['uuid']
	    nscan.uuid         = scan['uuid']
	    nscan.import_state = 'new'
	  end
	  nscan.status    = scan['status']
	  nscan.last_modification_date = Time.at(scan['last_modification_date'].to_i)
	  nscan.save!
	end
        Rails.logger.info "### #{scan_list.count} scans imported/updated"
      end
    else
      Rails.logger.error "### Could not authenticate, no scans listed"
    end
  end
end
