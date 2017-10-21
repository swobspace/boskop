module NetworkConcerns
  extend ActiveSupport::Concern

  included do
    def self.best_match(ip)
      return [] if ip.nil?
      networks = Network.
                   where("? << netzwerk", ip.to_s).
                   order("masklen(netzwerk) desc")
      if networks.any?
        masklen = networks.first.netzwerk.to_cidr_mask
        networks.where("masklen(netzwerk) >= ?", masklen)
      else
        []
      end
    end
  end

end

