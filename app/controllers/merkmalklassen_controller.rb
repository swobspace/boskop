class MerkmalklassenController < ApplicationController
  before_action :set_merkmalklasse, only: [:show, :edit, :update, :destroy]

  def index
    @merkmalklassen = Merkmalklasse.all
    respond_with(@merkmalklassen)
  end

  def show
    respond_with(@merkmalklasse)
  end

  def new
    @merkmalklasse = Merkmalklasse.new
    respond_with(@merkmalklasse)
  end

  def edit
  end

  def create
    @merkmalklasse = Merkmalklasse.new(merkmalklasse_params)
    @merkmalklasse.save
    respond_with(@merkmalklasse)
  end

  def update
    @merkmalklasse.update(merkmalklasse_params)
    respond_with(@merkmalklasse)
  end

  def destroy
    @merkmalklasse.destroy
    respond_with(@merkmalklasse)
  end

  private
    def set_merkmalklasse
      @merkmalklasse = Merkmalklasse.find(params[:id])
    end

    def merkmalklasse_params
      params.require(:merkmalklasse).
        permit(:name, :description, :format, :possible_values, 
               :for_object, :position, :mandantory, :unique, :visible)
    end
end
