## 
# Import OpenVAS xml data
# input: export an openvas report as xml
#
module Boskop
  module OpenVAS
    class XML
      include Enumerable
      attr_reader :file, :options, :error_message
      #
      # Creates a Boskop::OpenVAS::XML object
      #
      # required option:
      # * :file - openvas xml export file
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
            @error_message = "can't parse #{file}, may be wrong version or not an openvas xml file"
          end
        end
      end

      #
      # each iterator needed by Enumerable
      #
      def each(&block)
        return enum_for(__method__) unless block_given?
        @xmldoc.xpath("//report/results/result").each do |result|
          yield Result.new(result: result)
        end
      end

      #
      # return all results
      #
      def results
        each.to_a
      end

      #
      # return xml omp version
      #
      def omp_version
        @xmldoc.at('omp/version')&.inner_text
      end

      #
      # report_format of input file
      #
      def report_format
        @xmldoc.at('report_format/name')&.inner_text
      end

      #
      # starttime: scan start
      #
      def starttime
        @xmldoc.at('scan_start')&.inner_text&.to_time
      end


      #
      # valid?: return true if input file seems usable
      #
      def valid?
        return false if @xmldoc.blank?
        (report_format =~ /\A(Anonymous |)XML\z/) && (omp_version == "7.0")
      end
      
    end
  end
end
