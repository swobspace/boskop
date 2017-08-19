class HostCategoriesController < ApplicationController
  before_action :set_host_category, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /host_categories
  def index
    @host_categories = HostCategory.all
    respond_with(@host_categories)
  end

  # GET /host_categories/1
  def show
    respond_with(@host_category)
  end

  # GET /host_categories/new
  def new
    @host_category = HostCategory.new
    respond_with(@host_category)
  end

  # GET /host_categories/1/edit
  def edit
  end

  # POST /host_categories
  def create
    @host_category = HostCategory.new(host_category_params)

    @host_category.save
    respond_with(@host_category)
  end

  # PATCH/PUT /host_categories/1
  def update
    @host_category.update(host_category_params)
    respond_with(@host_category)
  end

  # DELETE /host_categories/1
  def destroy
    @host_category.destroy
    respond_with(@host_category)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_host_category
      @host_category = HostCategory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def host_category_params
      params.require(:host_category).permit(:name, :description)
    end
end
