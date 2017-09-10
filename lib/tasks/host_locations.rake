# assign location to host if network is uniq
# 

namespace :hosts do
  desc "assign location via networks"
  task :assign_location => :environment do
     
    # networks in 172.16.0.0/12 and 10.0.0.0/8 should be routable
    #
    Host.where(location_id: nil).
         where("ip << '172.16.0.0/12' or ip << '10.0.0.0/8'").
         each do |host|
      network = Network.where("? << netzwerk", host.ip.to_s).
                        where("masklen(netzwerk) > 15").
                        order("masklen(netzwerk) desc").first
      unless network.nil? or network.location_id.nil?
        host.update(location_id: network.location_id)
        puts "#{host.ip.to_s} -> #{network.location.lid}"
      end
    end
     
    # networks in 192.168.0.0/16 may be duplicate, so assign
    # only networks which are unique
    #
    Host.where(location_id: nil).
         where("ip << '192.168.0.0/16'").
         each do |host|
      networks = Network.where("? << netzwerk", host.ip.to_s).
                         where("masklen(netzwerk) > 16")
      if networks.count == 1 
        network = networks.first
        if !network.location_id.nil?
          host.update(location_id: network.location_id)
          puts "#{host.ip.to_s} -> #{network.location.lid}"
        end
      end
    end
  end
end
