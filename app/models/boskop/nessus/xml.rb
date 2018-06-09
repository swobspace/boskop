# 
# Import Nessus xml data export v2 (<scan>_<random>.nessus)
#
module Boskop
  module Nessus
    class XML
      include Enumerable
      attr_reader :file, :options, :error_message
      #
      # Creates a Boskop::Nessus::XML object
      #
      # required option:
      # * :file - nessus xml export file (v2, *.nessus)
      #
      def initialize(options = {})
        @error_message = nil
        @options = options.symbolize_keys!
        @file    = options.fetch(:file)
        if file.blank?
          @error_message = "empty or blank file"
        elsif !File.readable?(file)
          @error_message = "file #{file} is not readable or does not exist"
        else
          @xmldoc  = File.open(file) { |f| Nokogiri::XML(f) }
          unless valid?
            @error_message = "can't parse #{file}, may be wrong version or not an nessus xml v2 file"
          end
        end
      end

      #
      # each iterator needed by Enumerable
      #
      def each(&block)
        return enum_for(__method__) unless block_given?
        @xmldoc.xpath("//NessusClientData_v2/Report/ReportHost").each do |report_host|
          yield ReportHost.new(report_host: report_host)
        end
      end

      #
      # return all reports
      #
      def host_reports
        each.to_a
      end

      #
      # valid?: return true if input file seems usable
      #
      def valid?
        return false if @xmldoc.blank?
        @xmldoc.xpath("//NessusClientData_v2").present?
      end
      
    end
  end
end
