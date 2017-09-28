## 
# Result entry from OpenVAS XML aka Vulnerability
#
module Boskop
  module OpenVAS
    class Result
      attr_reader :options

      ATTRIBUTES = [:lastseen, :host, :name, :family, 
                    :cvss_base, :threat, :severity,
                    :nvt, :cves, :bids, :tags, :xrefs, :certs]

      #
      # Creates a Boskop::OpenVAS::Result object
      # the result object contains an existing vulnerability
      #
      def initialize(options = {})
        @options = options.symbolize_keys!
        @result  = options.fetch(:result)
      end

      #
      # return true if result seems an valid Nokogiri::XML::Node
      #
      def valid?
        @result.kind_of? Nokogiri::XML::Node
      end

      #
      # result date
      #
      def lastseen
        @result.at('creation_time')&.inner_text
      end

      #
      # ip address
      #
      def host
        @result.at('host')&.inner_text
      end

      #
      # name of nvt test
      #
      def name
        @result.at('nvt/name')&.inner_text
      end

      #
      # nvt family, i.e. "Windows : Microsoft Bulletins"
      #
      def family
        @result.at('nvt/family')&.inner_text
      end

      #
      # cvss score, i.e. "9.3"
      #
      def cvss_base
        @result.at('nvt/cvss_base')&.inner_text
      end

      #
      # threat level: Log, Low, Medium, High
      #
      def threat
        @result.at('threat')&.inner_text
      end

      #
      # Severity, mostly same as cvss score
      #
      def severity
        @result.at('severity')&.inner_text
      end

      #
      # OID for OpenVAS NVT test
      #
      def nvt
        @result.at("nvt")&.attr('oid')
      end

      #
      # related CVE numbers
      #
      def cves
        @result.at('nvt/cve')&.inner_text&.split(/,/).map(&:strip).
          reject{|c| c == "NOCVE" }
      end

      #
      # related bid numbers; www.securityfocus.com/bid/<number>
      #
      def bids
        @result.at('nvt/bid')&.inner_text&.split(/,/).map(&:strip).
          reject{|c| c == "NOBID" }
      end

      #
      # Cross reference hints
      #
      def xrefs
        @result.at('nvt/xref')&.inner_text&.split(/,/).map(&:strip).
          reject{|c| c == "NOXREF" }
      end

      #
      # tags
      #
      def tags
        Hash[@result.at('nvt/tags')&.inner_text&.split('|').map{|t| t.split('=', 2)}]
      end

      #
      # related cert id numbers
      #
      def certs
        @result.xpath('nvt/cert/cert_ref').map do |cert_ref|
          { id: cert_ref.attr('id'), type: cert_ref.attr('type') }
        end
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

