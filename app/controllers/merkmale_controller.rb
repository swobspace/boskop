class MerkmaleController < ApplicationController
  before_action :set_merkmal, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  def index
    @merkmale = Merkmal.all
    respond_with(@merkmale)
  end

  def show
    respond_with(@merkmal)
  end

  def new
    @merkmal = Merkmal.new
    respond_with(@merkmal)
  end

  def edit
  end

  def create
    @merkmal = Merkmal.new(merkmal_params)
    @merkmal.save
    respond_with(@merkmal)
  end

  def update
    @merkmal.update(merkmal_params)
    respond_with(@merkmal)
  end

  def destroy
    @merkmal.destroy
    respond_with(@merkmal)
  end

  private
    def set_merkmal
      @merkmal = Merkmal.find(params[:id])
    end

    def merkmal_params
      params.require(:merkmal).permit(:merkmalfor_id, :merkmalfor_type, :merkmalklasse_id, :value)
    end
end
