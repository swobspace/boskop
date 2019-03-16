## 
# ComputerSystemProduct from plugin 48337
#
module Boskop
  module Nessus
    class ComputerSystemProduct

      # Creates a Boskop::Nessus::ComputerSystemProduct object
      # input: Boskop::Nessus::ReportHost.new()

      def initialize(options = {})
        @options = options.symbolize_keys!
        report_host = options.fetch(:report_host, nil)
        if report_host.blank?
          raise KeyError, "option :report host is missing or blank"
        end
        @report_item = report_host.report_item(plugin_id: 48337)
      end

      def valid?
        report_item&.kind_of? Boskop::Nessus::ReportItem
      end

      def raw_output
        report_item&.plugin_output
      end

      def identifying_number
        get_entry("IdentifyingNumber")
      end

      def description
        get_entry("Description")
      end

      def vendor
        get_entry("Vendor")
      end

      def name
        get_entry("Name")
      end

      def uuid
        get_entry("UUID")
      end

      def version
        get_entry("Version")
      end

      def attributes
        { 
          serial: identifying_number,
          vendor: vendor,
          product: name,
          uuid: uuid
        }
      end

    private
      attr_reader :report_item, :options

      def get_entry(tag)
        entry = raw_output.split(/\n/).grep(/#{tag}/).first
        return nil if entry.blank?
        entry.match(/- #{tag}\s+: (.*)\z/)[1]
      end
  
    end
  end
end

