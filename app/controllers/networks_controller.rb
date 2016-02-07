class NetworksController < ApplicationController
  before_action :set_network, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]
  respond_to :html

  include NetworksControllerConcerns

  def search
  end

  def usage_form
  end

  def usage
    @subnets = generate_usage_map(usage_params)
    @merkmalklassen = Merkmalklasse.includes(:merkmale).visibles(:network, 'index')
  end

  def index
    @networks = filter_networks(search_params).includes(location: [:addresses])
    @merkmalklassen = Merkmalklasse.includes(:merkmale).visibles(:network, 'index')
    respond_with(@networks)
  end

  def show
    respond_with(@network)
  end

  def new
    @network = Network.new(new_network_params)
    merkmale
    respond_with(@network)
  end

  def edit
    merkmale
  end

  def create
    @network = Network.new(network_params)
    @network.save
    respond_with(@network)
  end

  def update
    @network.update(network_params)
    respond_with(@network)
  end

  def destroy
    @network.destroy
    respond_with(@network)
  end

  private
    def set_network
      @network = Network.find(params[:id])
    end

    def network_params
      params.require(:network).
             permit(:location_id, :netzwerk, :name, :description,
               [ merkmale_attributes:
                   [ :id, :value, :merkmalklasse_id, :_destroy ],
               ])
    end

    def new_network_params
      params.permit(:location_id, :netzwerk, :name, :description,
                    merkmale_attributes:
                     [ :id, :value, :merkmalklasse_id, :_destroy ],
                   )
    end

    def search_params
      params.permit(:cidr, :ort, :is_subset, :is_superset)
    end

    def usage_params
      params.permit(:cidr, :mask, :exact_match)
    end

    def merkmale
      merkmale = @network.merkmale.to_a
      exists    = merkmale.map {|m| m.merkmalklasse.id}
      klassen   = Merkmalklasse.where(for_object: Network.to_s)
      klassen.each do |kl|
        unless exists.include?(kl.id)
          @network.merkmale.build(merkmalklasse_id: kl.id)
        end
      end
    end

end
