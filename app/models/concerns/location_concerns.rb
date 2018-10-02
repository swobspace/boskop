require 'csv'

module LocationConcerns
  extend ActiveSupport::Concern

  included do
    def self.with_new_vulns_since(date)
       joins(:vulnerabilities).where("vulnerabilities.lastseen >= ?", date).distinct
    end
  end # included do

end

