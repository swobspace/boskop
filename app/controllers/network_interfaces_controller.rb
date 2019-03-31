class NetworkInterfacesController < ApplicationController
  before_action :set_network_interface, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /network_interfaces
  def index
    @network_interfaces = NetworkInterface.all
    respond_with(@network_interfaces)
  end

  # GET /network_interfaces/1
  def show
    respond_with(@network_interface)
  end

  # GET /network_interfaces/new
  def new
    @network_interface = NetworkInterface.new
    respond_with(@network_interface)
  end

  # GET /network_interfaces/1/edit
  def edit
  end

  # POST /network_interfaces
  def create
    @network_interface = NetworkInterface.new(network_interface_params)

    @network_interface.save
    respond_with(@network_interface)
  end

  # PATCH/PUT /network_interfaces/1
  def update
    @network_interface.update(network_interface_params)
    respond_with(@network_interface)
  end

  # DELETE /network_interfaces/1
  def destroy
    @network_interface.destroy
    respond_with(@network_interface)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_network_interface
      @network_interface = NetworkInterface.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def network_interface_params
      params.require(:network_interface).permit(:host_id, :description, :ip, :lastseen, :mac, :oui_vendor)
    end
end
