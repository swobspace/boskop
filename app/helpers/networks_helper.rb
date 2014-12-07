module NetworksHelper
  def sortable_network(net)
    if net.is_a? String
      net = IPAddr.new(net)
    end
    net.hton.unpack('C*').map{|x| sprintf('%03d', x)}.join('.')
  end
end
