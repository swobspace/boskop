class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
    respond_with(@locations)
  end

  def show
    respond_with(@location)
  end

  def new
    @location = Location.new
    merkmale(@location)
    respond_with(@location)
  end

  def edit
    merkmale(@location)
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
               [ merkmale_attributes: [ :id, :value ] ])
    end

    def merkmale(location)
      @merkmale = location.merkmale
      exists    = @merkmale.map {|m| m.merkmalklasse.id}
      klassen = Merkmalklasse.where(for_object: Location.to_s)
      klassen.each do |kl|
        unless exists.include?(kl.id)
          @merkmale << Merkmal.new(merkmalfor: location, merkmalklasse: kl)
        end
      end
    end
end
