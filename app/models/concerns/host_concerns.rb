module HostConcerns
  extend ActiveSupport::Concern

  included do
    def self.vuln_risk_matrix
      where("lastseen >= ?", 4.weeks.before(Date.today))
      .select("count(hosts.id) as count, hosts.vuln_risk, hosts.location_id")
      .group("location_id, vuln_risk")
      .map {|x| [x.vuln_risk, Location.where(id: x.location_id).first&.lid, x.count]}
    end
  end

end

