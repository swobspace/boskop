class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  def index
    @locations = Location.includes(:addresses, merkmale: [:merkmalklasse]).all
    @merkmalklassen = Merkmalklasse.visibles(:location, 'index')
    respond_with(@locations)
  end

  def show
    respond_with(@location)
  end

  def new
    @location = Location.new
    @location.addresses.build
    merkmale
    respond_with(@location)
  end

  def edit
    @location.addresses.build unless @location.addresses.any?
    merkmale
  end

  def create
    @location = Location.new(location_params)
    @location.save
    respond_with(@location)
  end

  def update
    @location.update(location_params)
    respond_with(@location)
  end

  def destroy
    @location.destroy
    respond_with(@location)
  end

  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).
             permit(:name, :description, :position, 
               [ merkmale_attributes: 
                   [ :id, :value, :merkmalklasse_id, :_destroy ],
                 addresses_attributes: 
                   [ :id, :ort, :plz, :streetaddress, :_destroy ]
               ])
    end

    def merkmale
      merkmale = @location.merkmale.to_a
      exists    = merkmale.map {|m| m.merkmalklasse.id}
      klassen   = Merkmalklasse.where(for_object: Location.to_s)
      klassen.each do |kl|
        unless exists.include?(kl.id)
          @location.merkmale.build(merkmalklasse_id: kl.id)
        end
      end
    end
end