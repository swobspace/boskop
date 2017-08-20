# require 'nmap/xml'
require 'resolv'
##
# NMAP Host data

module Boskop
  module NMAP
    class Host
      attr_reader :options
      alias_attribute :name, :hostname

      ATTRIBUTES = [:lastseen, :ip, :name, :status, :mac,
                    :lanmanager, :server, :fqdn, :cpe]

      # Boskop::NMAP::Host.new(nmaphost: <Nmap::Host>)
      # required option:
      # * +nmaphost+: instance of Nmap::Host

      def initialize(options = {})
	@options  = options.symbolize_keys!
	@nmaphost = options.fetch(:nmaphost)
      end

      def valid?
        nmaphost.kind_of? ::Nmap::Host
      end

      def attributes
        ATTRIBUTES.inject({}) {|hash,key| hash[key] = send(key) unless send(key).blank?; hash}
      end

      def lastseen
        nmaphost.start_time
      end

      [:ip, :hostname, :status, :mac].each do |attr|
        define_method(attr) { nmaphost.send(attr).to_s }
      end

      # windows product string
      def lanmanager
        smb_os_discovery['lanmanager']
      end

      # netbios name
      def server
        smb_os_discovery['server']
      end

      # full qualified domain name
      def fqdn
        smb_os_discovery['fqdn']
      end

      # common plattform enumeration
      def cpe
        smb_os_discovery['cpe']
      end

    private
      attr_reader :nmaphost

      def script_data
        if nmaphost.nil? || nmaphost.host_script.nil?
          {}
        else
          nmaphost.host_script.script_data
        end
      end

      def smb_os_discovery
        script_data['smb-os-discovery'] || {}
      end

      def is_ipv4?
        !!(ip =~ Resolv::IPv4::Regex)
      end
    end
  end
end
