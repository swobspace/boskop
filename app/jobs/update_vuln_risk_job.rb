class UpdateVulnRiskJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Host.where("lastseen >= ?", 4.weeks.before(Date.today)).each do |host|
      host.update_attributes!(vuln_risk: host.most_critical_vulnerability&.vulnerability_detail&.threat.to_s)
    end
  end
end
