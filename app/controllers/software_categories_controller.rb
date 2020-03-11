class SoftwareCategoriesController < ApplicationController
  before_action :set_software_category, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /software_categories
  def index
    @software_categories = SoftwareCategory.all
    respond_with(@software_categories)
  end

  # GET /software_categories/1
  def show
    respond_with(@software_category)
  end

  # GET /software_categories/new
  def new
    @software_category = SoftwareCategory.new
    respond_with(@software_category)
  end

  # GET /software_categories/1/edit
  def edit
  end

  # POST /software_categories
  def create
    @software_category = SoftwareCategory.new(software_category_params)

    @software_category.save
    respond_with(@software_category)
  end

  # PATCH/PUT /software_categories/1
  def update
    @software_category.update(software_category_params)
    respond_with(@software_category)
  end

  # DELETE /software_categories/1
  def destroy
    @software_category.destroy
    respond_with(@software_category)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_software_category
      @software_category = SoftwareCategory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def software_category_params
      params.require(:software_category).permit(:name, :description, :main_business_process, :software_group_id)
    end
end
