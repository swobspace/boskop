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

      UPREASONS = [ 'arp-response', 'echo-reply', 'timestamp-reply', 'syn-ack' ]

      # Boskop::NMAP::Host.new(nmaphost: <Nmap::Host>)
      # required option:
      # * nmaphost: instance of Nmap::Host
      # optional:
      # * starttime: starttime from nmap scanner start (xml)

      def initialize(options = {})
	@options  = options.symbolize_keys!
	@nmaphost = options.fetch(:nmaphost)
	@xmlstart = options.fetch(:starttime, nil)
      end

      def valid?
        nmaphost.kind_of? ::Nmap::Host
      end

      def attributes
        ATTRIBUTES.inject({}) {|hash,key| hash[key] = send(key) unless send(key).blank?; hash}
      end

      def lastseen
        if nmaphost.start_time.to_i == 0
          xmlstart
        else
          nmaphost.start_time
        end
      end

      [:ip, :mac, :vendor].each do |attr|
        define_method(attr) { nmaphost.send(attr).to_s }
      end

      def hostname
        nmaphost.hostname&.name || fqdn
      end

      def status
        return 'down' if (nmaphost.status&.state == :down)
        if UPREASONS.include?(nmaphost.status&.reason) || nmaphost.open_ports.any?
          'up'
        else
          'down'
        end
      end

      def up?
        status == 'up'
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
        smb_os_discovery['cpe']&.sub(/cpe:/, '')
      end

    private
      attr_reader :nmaphost, :xmlstart

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
