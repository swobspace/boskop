## 
# Report Item from Nessus Report/ReportHost
#
module Boskop
  module Nessus
    class ReportItem
      include Enumerable
      attr_reader :options

      ATTRIBUTES = [:oid, :description]

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
        @report_item.kind_of? Nokogiri::XML::Node
      end

      #
      # report_item date
      #
      def oid
        ""
      end

      #
      # description
      #
      def mac
        @report_item.at("description")&.inner_text
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

