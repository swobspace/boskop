require 'csv'

module HostConcerns
  extend ActiveSupport::Concern

  included do
    def self.vuln_risk_matrix
      where("lastseen >= ?", 4.weeks.before(Date.today))
      .select("count(hosts.id) as count, hosts.vuln_risk, hosts.location_id")
      .group("location_id, vuln_risk")
      .map do |x| 
        {
          risk: ( x.vuln_risk.blank?  ? "None" : x.vuln_risk ), 
          lid: Location.where(id: x.location_id).first&.lid, 
          count: x.count
        }
      end
    end

    def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << [ 
                I18n.t('attributes.name'),
		I18n.t('attributes.description'),
		I18n.t('attributes.ip'),
		I18n.t('attributes.operating_system'),
		I18n.t('attributes.cpe'),
		I18n.t('attributes.raw_os'),
		I18n.t('attributes.fqdn'),
		I18n.t('attributes.domain_dns'),
		I18n.t('attributes.workgroup'),
		I18n.t('attributes.lastseen'),
		I18n.t('attributes.vuln_risk'),
		I18n.t('attributes.mac'),
		I18n.t('attributes.vendor'),
		I18n.t('attributes.host_category'),
		I18n.t('attributes.location'),
               ] 

        all.each do |host|
          csv << [ 
		  host.name,
		  host.description,
		  host.ip.to_s,
		  host.operating_system.to_s,
		  host.cpe,
		  host.raw_os,
		  host.fqdn,
		  host.domain_dns,
		  host.workgroup,
		  host.lastseen,
		  host.vuln_risk,
		  host.mac,
		  host.vendor,
		  host.host_category.to_s,
		  host.location.try(:lid),
                 ]
        end # all.each
      end # CSV
    end # self.to_csv
  end # included do
end

