class OrgUnitsController < ApplicationController
  before_action :set_org_unit, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  def index
    @org_units = OrgUnit.all
    @merkmalklassen = Merkmalklasse.visibles(:org_unit, 'index')
    respond_with(@org_units)
  end

  def show
    respond_with(@org_unit)
  end

  def new
    @org_unit = OrgUnit.new
    @org_unit.addresses.build
    merkmale
    respond_with(@org_unit)
  end

  def edit
    @org_unit.addresses.build unless @org_unit.addresses.any?
    merkmale
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
      params.require(:org_unit).
             permit(:name, :description, :position,
               [ merkmale_attributes:
                   [ :id, :value, :merkmalklasse_id, :_destroy ],
                 addresses_attributes:
                   [ :id, :ort, :plz, :streetaddress, :_destroy ]
               ])

    end

    def merkmale
      merkmale = @org_unit.merkmale.to_a
      exists    = merkmale.map {|m| m.merkmalklasse.id}
      klassen   = Merkmalklasse.where(for_object: OrgUnit.to_s)
      klassen.each do |kl|
        unless exists.include?(kl.id)
          @org_unit.merkmale.build(merkmalklasse_id: kl.id)
        end
      end
    end
end
