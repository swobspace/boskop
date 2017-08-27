# require 'nmap/xml'
require 'resolv'
##
# NMAP Host data

module Boskop
  module NMAP
    class Host
      attr_reader :options
      alias_attribute :name, :hostname

      ATTRIBUTES = [:lastseen, :ip, :name, :status, :mac, :vendor,
                    :fqdn, :domain_dns, :workgroup,
                    :raw_os, :server, :fqdn, :cpe]

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

      [:ip, :hostname, :status, :mac, :vendor].each do |attr|
        define_method(attr) { nmaphost.send(attr).to_s }
      end

      # windows product string
      def raw_os
        smb_os_discovery['os']
      end

      # netbios name
      def server
        smb_os_discovery['server'].to_s.gsub(/\\x00/,'')
      end

      # full qualified domain name
      def fqdn
        smb_os_discovery['fqdn']
      end

      # windows workgroup
      def workgroup
        smb_os_discovery['workgroup'].to_s.gsub(/\\x00/,'')
      end

      # full qualified domain from smb-os-discovery (windows)
      def domain_dns
        smb_os_discovery['domain_dns']
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
        # smb-os-discovery is [] if an script error in case of
        # ERROR: Script execution failed (use -d to debug)"
        if script_data['smb-os-discovery'].nil? || script_data['smb-os-discovery'].empty?
          {}
        else
          script_data['smb-os-discovery']
        end
      end

      def is_ipv4?
        !!(ip =~ Resolv::IPv4::Regex)
      end
    end
  end
end
