require 'csv'

module LocationConcerns
  extend ActiveSupport::Concern

  included do
    def self.with_new_vulns_since(date)
      joins(:vulnerabilities).where("vulnerabilities.lastseen >= ?", date).distinct
    end
    def self.with_new_vulns_at(date)
      joins(:vulnerabilities).where("vulnerabilities.lastseen = ?", date).distinct
    end
    def self.with_new_vulns(options)
      options.symbolize_keys!
      since = options.fetch(:since, false)
      at = options.fetch(:at, false)
      if since
        self.with_new_vulns_since(since)
      elsif at
        self.with_new_vulns_at(at)
      else
        raise ArgumentError, "choose one of :at or :since; #{options.inspect} is not valid"
      end
    end
  end # included do

end

