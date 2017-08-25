require 'nmap/xml'
##
# Import NMAP xml data from scan

module Boskop
  module NMAP
    class XML
      attr_reader :file, :options, :error_message

      # Boskop::NMAP.new(file: scanme.nmap.org.xml)
      # required option:
      # * +file+: nmap xml output file from scan

      def initialize(options = {})
	@options = options.symbolize_keys!
	@file    = options.fetch(:file)
	@xml     = Nmap::XML.new(file)
        @error_message = nil
	if xml.scan_info.present?
          @valid = true
	else
	  @xml = nil
          @valid = false
          @error_message = "can't parse #{file}, seems not to be a nmap xml file"
	end
      end

      def valid?
        !!@valid
      end

      def all_hosts
        xml.hosts.map {|host| Boskop::NMAP::Host.new(nmaphost: host)}
      end

    private
      attr_reader :xml

    end
  end
end
