require 'resolv'
## 
# ReportHost entry from Nessus XML
#
module Boskop
  module Nessus
    class ReportHost
      include Enumerable
      attr_reader :options

      #
      # (host) attributes
      #
      ATTRIBUTES = [:lastseen, :ip, :name, :mac,
                    :raw_os, :fqdn ]

      #
      # Creates a Boskop::Nessus::ReportHost object
      # the report_host object contains host info and vulns reports
      #
      def initialize(options = {})
        @options      = options.symbolize_keys!
        @report_host  = options.fetch(:report_host)
      end

      #
      # return true if report_host seems an valid Nokogiri::XML::Node
      #
      def valid?
        @report_host.kind_of? Nokogiri::XML::Node
      end

      #
      # report_host date
      #
      def lastseen
        DateTime.parse(@report_host.at("HostProperties/tag[@name='HOST_START']")&.inner_text).to_s
      end

      #
      # ip address
      #
      def ip
        host_ip || node_name_ip
      end

      #
      # host-ip
      #
      def host_ip
        @report_host.at("HostProperties/tag[@name='host-ip']")&.inner_text
      end

      #
      # node_name_ip: get ip from node name if possible
      #
      def node_name_ip
        if node_name =~ Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex)
          node_name
        else
          nil
        end
      end

      #
      # node_name
      #
      def node_name
        @report_host['name']
      end

      #
      # netbios name
      #
      def name
        @report_host.at("HostProperties/tag[@name='netbios-name']")&.inner_text
      end

      #
      # fqdn
      #
      def fqdn
        @report_host.at("HostProperties/tag[@name='host-fqdn']")&.inner_text
      end

      #
      # mac
      #
      def mac
        @report_host.at("HostProperties/tag[@name='mac-address']")&.inner_text
      end

      #
      # raw_os
      #
      def raw_os
        @report_host.at("HostProperties/tag[@name='operating-system']")&.inner_text
      end

      #
      # all attributes to create a Vulnerability and a VulnerabilityDetail
      #
      def attributes
        ATTRIBUTES.inject({}) {|hash,key| hash[key] = send(key) unless send(key).blank?; hash}

      end

      #
      # each iterator needed by Enumerable
      #
      def each(&block)
        return enum_for(__method__) unless block_given?
        @report_host.xpath("ReportItem").each do |report_item|
          yield ReportItem.new(report_item: report_item)
        end
      end

      #
      # return all reports
      #
      def report_items
        each.to_a
      end

    end
  end
end

