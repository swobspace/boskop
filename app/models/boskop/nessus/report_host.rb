## 
# Host entry from Nessus XML aka Vulnerability
#
module Boskop
  module Nessus
    class ReportHost
      attr_reader :options

      ATTRIBUTES = [:lastseen, :ip, :name, :mac,
                    :raw_os, :fqdn ]

      #
      # Creates a Boskop::Nessus::Host object
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
        @report_host.at("HostProperties/tag[@name='host-ip']")&.inner_text
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

    end
  end
end

