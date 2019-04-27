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
      locations = Location.with_new_vulns(since_or_at(:location))
    end

    locations.each do |location|
      recipients = Array(mail_to) + Array(location.vuln_responsible_mail)
      vulns = VulnerabilityQuery.new(location.vulnerabilities, since_or_at).all
      VulnerabilitiesMailer.
        send_csv(vulnerabilities: vulns, mail_to: recipients, lid: location.lid).
        deliver_now
    end
  end

private

  def since_or_at(mode = :vulnerability)
    sat = @options.slice(:since, :at)
    if sat.empty? 
      sat = { since: Date.today }
    end
    # special mode for "nessus scan started yesterday and ended today"
    if sat[:at].present? and mode == :vulnerability
      sat = { since: 1.day.before(sat[:at]) }
    else
      sat
    end
  end

end
