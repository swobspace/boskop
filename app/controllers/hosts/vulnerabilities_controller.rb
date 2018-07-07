class Hosts::VulnerabilitiesController < VulnerabilitiesController
  before_action :set_host

private

  def set_host
    @host = Host.find(params[:host_id])
  end
end

