class NetworksController < ApplicationController
  before_action :set_network, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]
  respond_to :html

  include NetworksControllerConcerns

  def search_form
    @merkmalklassen = Merkmalklasse.includes(:merkmale).visibles(:network, 'index')
  end

  def search
    @networks = @networks.left_outer_joins(:merkmale, :location).distinct
    query = NetworkQuery.new(@networks, search_params) 
    @filter_info = query.search_options
    @networks = query.all
    @merkmalklassen = Merkmalklasse.includes(:merkmale).visibles(:network, 'index')
  end

  def usage_form
  end

  def usage
    @subnets = generate_usage_map(usage_params)
    @merkmalklassen = Merkmalklasse.includes(:merkmale).visibles(:network, 'index')
  end

  def index
    @networks = @networks.left_outer_joins(:merkmale, :location).distinct
    @merkmalklassen = Merkmalklasse.includes(:merkmale).visibles(:network, 'index')
    respond_with(@networks) do |format|
      format.json { render json: NetworksDatatable.new(@networks, view_context) }
    end

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
      searchparms = params.permit(*submit_parms,
                                  *merkmal_parms,
                                  :netzwerk, :ort, :limit, :lid, :description,
                                  :is_subset, :is_superset).to_hash
      {limit: 100}
        .merge(searchparms)
        .reject{|k, v| (v.blank? || submit_parms.include?(k))}
    end

    def merkmal_parms
      @merkmalklassen = Merkmalklasse.visibles(:network, 'index').map{|m| "merkmal_#{m.tag}"}
    end

    def usage_params
      params.permit(:utf8, :authenticity_token, :cidr, :mask, :exact_match)
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

    def submit_parms
      [ "utf8", "authenticity_token", "commit", "format" ]
    end

end
