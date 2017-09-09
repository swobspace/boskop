class OperatingSystemMappingsController < ApplicationController
  before_action :set_operating_system_mapping, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /operating_system_mappings
  def index
    @operating_system_mappings = OperatingSystemMapping.all
    respond_with(@operating_system_mappings)
  end

  # GET /operating_system_mappings/1
  def show
    respond_with(@operating_system_mapping)
  end

  # GET /operating_system_mappings/new
  def new
    @operating_system_mapping = OperatingSystemMapping.new
    respond_with(@operating_system_mapping)
  end

  # GET /operating_system_mappings/1/edit
  def edit
  end

  # POST /operating_system_mappings
  def create
    @operating_system_mapping = OperatingSystemMapping.new(operating_system_mapping_params)

    @operating_system_mapping.save
    respond_with(@operating_system_mapping)
  end

  # PATCH/PUT /operating_system_mappings/1
  def update
    @operating_system_mapping.update(operating_system_mapping_params)
    respond_with(@operating_system_mapping)
  end

  # DELETE /operating_system_mappings/1
  def destroy
    @operating_system_mapping.destroy
    respond_with(@operating_system_mapping)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operating_system_mapping
      @operating_system_mapping = OperatingSystemMapping.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def operating_system_mapping_params
      params.require(:operating_system_mapping).permit(:field, :value, :operating_system_id)
    end
end
