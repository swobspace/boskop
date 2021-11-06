class FrameworkContracts::LinesController < LinesController
  before_action :set_framework_contract

private

  def set_framework_contract
    @framework_contract = FrameworkContract.find(params[:framework_contract_id])
  end

  def location
    framework_contract_path(@framework_contract)
  end

end

