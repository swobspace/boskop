class SendVulnerabilitiesMailJob < ApplicationJob
  queue_as :default

  def perform(options)
    options.symbolize_keys!
    since   = options.fetch(:since, Date.today)
    mail_to = options.fetch(:mail_to)
    lid     = options.fetch(:lid, false)

    if lid
      locations = Location.where(lid: lid).limit(1)
    else
      raise RuntimeError, "not yet implemented"
    # locations = Location.with_new_vulns_since(since)
    end

    locations.each do |location|
      vulns = location.vulnerabilities.higher.current
      VulnerabilitiesMailer.
        send_csv(vulnerabilities: vulns, mail_to: mail_to, lid: lid).
        deliver_now
    end

  end
end
