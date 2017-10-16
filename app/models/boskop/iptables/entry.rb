module Boskop
  module Iptables
    class Entry
      attr_reader :line

      VALUE_ATTRIBUTES = %w(IN OUT MAC SRC DST LEN TOS PREC TTL ID SPT DPT WINDOW RES )
      BOOL_ATTRIBUTES = %w( DF SYN AC PSH URG FIN RST )
      #
      # Boskop::Iptables::Entry.new(logline)
      # logline must be a single line from LOG target (string)
      #
      def initialize(logline)
        @line = logline
      end

      def valid?
        @line =~ /IN=.*OUT=.*SRC=.*DST=.*/
      end

      VALUE_ATTRIBUTES.each do |vattr|
        define_method(vattr.downcase) do
          line =~ /#{vattr}=([^ ]*)/
          return $1
        end
      end

      def dst_mac
        mac[0..16]
      end

      def src_mac
        mac[18..34]
      end

      def etherproto
        mac[36..40]
      end
      # Oct 16 18:39:34 gate kernel: /PF/ AHINT 

      def timestamp
        Time.parse(line[0..15])
      end

      def host
        line[16..-1] =~ /([^ ]+)/
        $1
      end
    end
  end
end
