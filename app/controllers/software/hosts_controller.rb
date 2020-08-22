class Software::HostsController < HostsController
  before_action :set_software

private

  def set_software
    @hostable = Software.find(params[:software_id])
  end
end

