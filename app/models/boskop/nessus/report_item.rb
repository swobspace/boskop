## 
# Report Item from Nessus Report/ReportHost
#
module Boskop
  module Nessus
    class ReportItem
      include Enumerable
      attr_reader :options

      alias_attribute :nvt, :oid

      ATTRIBUTES = [:nvt, :name, :family, :cvss_base,
                    :threat, :severity, :cves, :bids, :xrefs,
                    :notes, :description, :synopsis, :see_also, :solution,
                    :vuln_publication_date, :patch_publication_date, 
                    :exploit_available, :exploited_by_malware  ]

      #
      # Creates a Boskop::Nessus::ReportItem object
      # the report_item object contains host info and vulns reports
      #
      def initialize(options = {})
        @options      = options.symbolize_keys!
        @report_item  = options.fetch(:report_item)
      end

      #
      # return true if report_item seems an valid Nokogiri::XML::Node
      #
      def valid?
        @report_item&.node_name == "ReportItem"
      end

      #
      # nessus plugin id
      #
      def oid
        "nessus:#{@report_item&.attr('pluginID')}"
      end

      #
      # family
      #
      def family
        @report_item&.attr('pluginFamily')
      end

      #
      # name
      #
      def name
        @report_item.at("plugin_name")&.inner_text
      end

      #
      # cvss_base
      #
      def cvss_base
	@report_item.at("cvss_base_score")&.inner_text
      end

      #
      # threat
      #
      def threat
	@report_item.at("risk_factor")&.inner_text
      end

      #
      # severity
      #
      def severity
	@report_item.at("cvss_base_score")&.inner_text
      end

      #
      # cves
      #
      def cves
        @report_item.xpath('cve').map(&:inner_text)
      end

      #
      # bids
      #
      def bids
        @report_item.xpath('bid').map(&:inner_text)
      end

      #
      # xrefs
      #
      def xrefs
        @report_item.xpath('xref').map(&:inner_text)
      end

      #
      # notes
      #
      # :notes, :description, :synopsis, :see_also, :solution,
      # :vuln_publication_date, :patch_publication_date,
      # :exploit_available, :exploited_by_malware
      def notes
      {
        synopsis: synopsis,
        description: description,
        see_also: see_also,
        solution: solution,
        vuln_publication_date: vuln_publication_date,
        patch_publication_date: patch_publication_date,
        exploit_available: exploit_available,
        exploited_by_malware: exploited_by_malware,
      }
      end

      #
      # description
      #
      def description
	@report_item.at("description")&.inner_text
      end

      #
      # synopsis
      #
      def synopsis
	@report_item.at("synopsis")&.inner_text
      end

      #
      # see_also
      #
      def see_also
	@report_item.at("see_also")&.inner_text
      end

      #
      # solution
      #
      def solution
	@report_item.at("solution")&.inner_text
      end

      #
      # vuln_publication_date
      #
      def vuln_publication_date
	@report_item.at("vuln_publication_date")&.inner_text
      end

      #
      # patch_publication_date
      #
      def patch_publication_date
	@report_item.at("patch_publication_date")&.inner_text
      end

      #
      # exploit_available
      #
      def exploit_available
	@report_item.at("exploit_available")&.inner_text
      end

      #
      # exploited_by_malware
      #
      def exploited_by_malware
	@report_item.at("exploited_by_malware")&.inner_text
      end

      #
      # plugin_output
      #
      def plugin_output
        @report_item.at("plugin_output")&.inner_text
      end

      #
      # all attributes to create a Vulnerability and a VulnerabilityDetail
      #
      def attributes
        ATTRIBUTES.inject({}) {|hash,key| hash[key] = send(key) unless send(key).blank?; hash}
      end
    end
  end
end

