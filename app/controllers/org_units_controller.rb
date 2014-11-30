class OrgUnitsController < ApplicationController
  before_action :set_org_unit, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @org_units = OrgUnit.all
    respond_with(@org_units)
  end

  def show
    respond_with(@org_unit)
  end

  def new
    @org_unit = OrgUnit.new
    respond_with(@org_unit)
  end

  def edit
  end

  def create
    @org_unit = OrgUnit.new(org_unit_params)
    @org_unit.save
    respond_with(@org_unit)
  end

  def update
    @org_unit.update(org_unit_params)
    respond_with(@org_unit)
  end

  def destroy
    @org_unit.destroy
    respond_with(@org_unit)
  end

  private
    def set_org_unit
      @org_unit = OrgUnit.find(params[:id])
    end

    def org_unit_params
      params.require(:org_unit).permit(:name, :description, :ancestry, :ancestry_depth, :position)
    end
end
