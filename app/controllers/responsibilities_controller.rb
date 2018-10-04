class ResponsibilitiesController < ApplicationController
  before_action :set_responsibility, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /responsibilities
  def index
    respond_with(@responsibilities)
  end

  # GET /responsibilities/1
  def show
    respond_with(@responsibility)
  end

  # GET /responsibilities/new
  def new
    @responsibility = Responsibility.new
    respond_with(@responsibility)
  end

  # GET /responsibilities/1/edit
  def edit
  end

  # POST /responsibilities
  def create
    @responsibility = Responsibility.new(responsibility_params)

    @responsibility.save
    respond_with(@responsibility)
  end

  # PATCH/PUT /responsibilities/1
  def update
    @responsibility.update(responsibility_params)
    respond_with(@responsibility)
  end

  # DELETE /responsibilities/1
  def destroy
    @responsibility.destroy
    respond_with(@responsibility)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_responsibility
      @responsibility = Responsibility.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def responsibility_params
      params.require(:responsibility).permit(:responsibility_for_id, :responsibility_for_type, :contact_id, :role, :title, :position)
    end
end
