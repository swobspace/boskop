class AccessTypesController < ApplicationController
  before_action :set_access_type, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /access_types
  def index
    @access_types = AccessType.all
    respond_with(@access_types)
  end

  # GET /access_types/1
  def show
    respond_with(@access_type)
  end

  # GET /access_types/new
  def new
    @access_type = AccessType.new
    respond_with(@access_type)
  end

  # GET /access_types/1/edit
  def edit
  end

  # POST /access_types
  def create
    @access_type = AccessType.new(access_type_params)

    @access_type.save
    respond_with(@access_type)
  end

  # PATCH/PUT /access_types/1
  def update
    @access_type.update(access_type_params)
    respond_with(@access_type)
  end

  # DELETE /access_types/1
  def destroy
    @access_type.destroy
    respond_with(@access_type)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access_type
      @access_type = AccessType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def access_type_params
      params.require(:access_type).permit(:name, :description)
    end
end
