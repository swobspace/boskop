require 'cidr_addresses'

module NetworksControllerConcerns
  extend ActiveSupport::Concern

  included do
  end

  def filter_networks(search_params)
    @search_params = search_params
    networks = Network.accessible_by(current_ability, :read)
    if cidr.present?
      if (is_subset? or is_superset?)
        sub_ids = []
        super_ids = []
        if is_subset?
          sub_ids = networks.where("netzwerk <<= ?", cidr).pluck(:id)
        end
        if is_superset?
          super_ids = networks.where("netzwerk >>= ?", cidr).pluck(:id)
        end
        networks = networks.where(['networks.id in (?)', sub_ids + super_ids])
      else
        networks = networks.where(netzwerk: cidr)
      end
    end
    if ort.present?
      networks = networks.joins(location: :addresses).
                 where(["addresses.ort like ?", "%#{ort}%"])
    end
    networks
  end

def generate_usage_map(usage_params)
    hash   = Hash.new
    parent = IPAddr.new(usage_params.fetch('cidr', '192.0.2.0/24'))
    mask   = usage_params.fetch('mask', 24).to_i
    exact_match = usage_params.fetch('exact_match', false)
    subnet = parent.mask(mask)
    bitstep = 2**(32 - mask)

    while parent.include?(subnet) do
      if exact_match
        nets = Network.includes(:location).where(netzwerk: subnet)
      else
        nets = Network.includes(:location).where("netzwerk >>= ?", subnet.to_cidr_s)
        nets += Network.includes(:location).where("netzwerk << ?", subnet.to_cidr_s)
      end
      hash[subnet.to_cidr_s] = nets
      nextsubnet = subnet.to_i + bitstep
      subnet = IPAddr.new(nextsubnet, Socket::AF_INET).mask(mask)
    end
    return hash
  end

  private

  def cidr
    @search_params[:cidr]
  end

  def ort
    @search_params[:ort]
  end

  def is_superset?
    @search_params[:is_superset].present?
  end

  def is_subset?
    @search_params[:is_subset].present?
  end

end
