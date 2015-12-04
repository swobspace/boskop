class FrameworkContractsController < ApplicationController
  before_action :set_framework_contract, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /framework_contracts
  def index
    @framework_contracts = FrameworkContract.all
    respond_with(@framework_contracts)
  end

  # GET /framework_contracts/1
  def show
    respond_with(@framework_contract)
  end

  # GET /framework_contracts/new
  def new
    @framework_contract = FrameworkContract.new
    respond_with(@framework_contract)
  end

  # GET /framework_contracts/1/edit
  def edit
  end

  # POST /framework_contracts
  def create
    @framework_contract = FrameworkContract.new(framework_contract_params)

    @framework_contract.save
    respond_with(@framework_contract)
  end

  # PATCH/PUT /framework_contracts/1
  def update
    @framework_contract.update(framework_contract_params)
    respond_with(@framework_contract)
  end

  # DELETE /framework_contracts/1
  def destroy
    @framework_contract.destroy
    respond_with(@framework_contract)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_framework_contract
      @framework_contract = FrameworkContract.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def framework_contract_params
      params.require(:framework_contract).permit(:name, :description, :contract_start, :contract_end, :contract_period, :period_of_notice, :period_of_notice_unit, :renewal_period, :renewal_unit, :active)
    end
end
