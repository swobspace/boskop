require 'csv'

module LocationConcerns
  extend ActiveSupport::Concern

  included do
    def self.with_new_vulns_since(date)
       joins(:vulnerabilities).where("vulnerabilities.lastseen >= ?", date).distinct
    end
  end # included do

  def vuln_responsible_mail
    responsibilities.where(role: 'Vulnerabilities').joins(:contact).pluck('contacts.mail')
  end

end

