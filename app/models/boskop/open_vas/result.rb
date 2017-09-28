## 
# Result entry from OpenVAS XML aka Vulnerability
#
module Boskop
  module OpenVAS
    class Result
      #
      # Creates a Boskop::OpenVAS::Result object
      # the result object contains an existing vulnerability
      #
      def initialize(options = {})
        @options = options.symbolize_keys!
        @result  = options.fetch(:result)
      end
    end
  end
end

