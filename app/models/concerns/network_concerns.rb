module NetworkConcerns
  extend ActiveSupport::Concern

  included do
    def self.best_match(ip)
      networks = Network.
                   where("? << netzwerk", ip.to_s).
                   order("masklen(netzwerk) desc")
      masklen = networks.first.netzwerk.to_cidr_mask
      networks.where("masklen(netzwerk) >= ?", masklen)
    end
  end

end

