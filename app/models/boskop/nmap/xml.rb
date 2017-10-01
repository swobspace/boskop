require 'nmap/xml'
##
# Import NMAP xml data from scan

module Boskop
  module NMAP
    class XML
      attr_reader :file, :options, :error_message, :starttime

      # Boskop::NMAP::XML.new(file: scanme.nmap.org.xml)
      #
      # required option:
      # * :file - nmap xml output file from scan
      #
      def initialize(options = {})
	@xml = nil
        @valid = false
	@options = options.symbolize_keys!
	@file    = options.fetch(:file)
        @error_message = nil
        if file.blank?
          @error_message = "empty or blank file"
        elsif !File.readable?(file)
          @error_message = "file #{file} is not readable or does not exist"
        else
	  @xml  = ::Nmap::XML.new(file)
          if File.open(file, 'rb').grep(/nmaprun/).count >= 3 &&
             xml.scanner.present?
            @valid = true
            @starttime = xml.scanner.start_time
	  else
	    @xml = nil
            @error_message = "can't parse #{file}, seems not to be a nmap xml file"
	  end
        end
      end

      def valid?
        !!@valid
      end

      # all_hosts(force: false)
      #
      # optional:
      # * :force - false: select only host which are 'up'
      #            true: select all hosts (including 'down' hosts)
      #
      def all_hosts(options = {})
        if options.fetch(:force, false) == false
          xml.up_hosts.map {|host| Boskop::NMAP::Host.new(nmaphost: host, starttime: starttime)}.select {|host| host.up? }
        else
          xml.hosts.map {|host| Boskop::NMAP::Host.new(nmaphost: host, starttime: starttime)}
        end
      end

    private
      attr_reader :xml

    end
  end
end
