class SoftwaresController < ApplicationController
  before_action :set_software, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /softwares
  def index
    @softwares = Software.all
    respond_with(@softwares)
  end

  # GET /softwares/1
  def show
    respond_with(@software)
  end

  # GET /softwares/new
  def new
    @software = Software.new
    respond_with(@software)
  end

  # GET /softwares/1/edit
  def edit
  end

  # POST /softwares
  def create
    @software = Software.new(software_params)

    @software.save
    respond_with(@software)
  end

  # PATCH/PUT /softwares/1
  def update
    @software.update(software_params)
    respond_with(@software)
  end

  # DELETE /softwares/1
  def destroy
    @software.destroy
    respond_with(@software)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_software
      @software = Software.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def software_params
      params.require(:software).permit(:name, :pattern, :vendor, :description, :minimum_allowed_version, :maximum_allowed_version, :green, :yellow, :red, :software_category_id)
    end
end
