class Software::SoftwareRawDataController < SoftwareRawDataController
  before_action :set_software

private

  def set_software
    @software = Software.find(params[:software_id])
  end
end

