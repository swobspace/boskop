class OperatingSystemsController < ApplicationController
  before_action :set_operating_system, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /operating_systems
  def index
    @operating_systems = OperatingSystem.all
    respond_with(@operating_systems)
  end

  # GET /operating_systems/1
  def show
    respond_with(@operating_system)
  end

  # GET /operating_systems/new
  def new
    @operating_system = OperatingSystem.new
    respond_with(@operating_system)
  end

  # GET /operating_systems/1/edit
  def edit
  end

  # POST /operating_systems
  def create
    @operating_system = OperatingSystem.new(operating_system_params)

    @operating_system.save
    respond_with(@operating_system)
  end

  # PATCH/PUT /operating_systems/1
  def update
    @operating_system.update(operating_system_params)
    respond_with(@operating_system)
  end

  # DELETE /operating_systems/1
  def destroy
    @operating_system.destroy
    respond_with(@operating_system)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operating_system
      @operating_system = OperatingSystem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def operating_system_params
      params.require(:operating_system).permit(:name, :eol, :matching_pattern)
    end
end
