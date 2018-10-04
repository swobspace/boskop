class SendVulnerabilitiesMailJob < ApplicationJob
  queue_as :default

  #
  # SendVulnerabilitiesMailJob.perform_now(options)
  #
  # possible options:
  # * since: (date)
  # * at: (date)
  # * mail_to: (string or array) additional mail addresses
  # * lid: (string) location shortcut
  #
  def perform(options = {})
    @options = options.symbolize_keys!
    mail_to = Array(options.fetch(:mail_to, []))
    lid     = options.fetch(:lid, false)

    if lid
      locations = Location.where(lid: lid).limit(1)
    else
      locations = Location.with_new_vulns(since_or_at)
    end

    locations.each do |location|
      recipients = Array(mail_to) + Array(location.vuln_responsible_mail)
      vulns = location.vulnerabilities.higher.current
      VulnerabilitiesMailer.
        send_csv(vulnerabilities: vulns, mail_to: recipients, lid: location.lid).
        deliver_now
    end
  end

private

  def since_or_at
    sat = @options.slice(:since, :at)
    if sat.empty?
      sat = { since: Date.today }
    end
    sat
  end

end
