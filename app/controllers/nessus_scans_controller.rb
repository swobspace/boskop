class NessusScansController < ApplicationController
  before_action :set_nessus_scan, only: [:show, :edit, :update, :destroy, :import]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /nessus_scans
  def index
    @nessus_scans = NessusScan.all
    respond_with(@nessus_scans)
  end

  # GET /nessus_scans/1
  def show
    respond_with(@nessus_scan)
  end

  # GET /nessus_scans/new
  def new
    @nessus_scan = NessusScan.new
    respond_with(@nessus_scan)
  end

  # GET /nessus_scans/1/edit
  def edit
  end

  # POST /nessus_scans
  def create
    @nessus_scan = NessusScan.new(nessus_scan_params)

    @nessus_scan.save
    respond_with(@nessus_scan)
  end

  # PATCH/PUT /nessus_scans/1
  def update
    @nessus_scan.update(nessus_scan_params)
    respond_with(@nessus_scan)
  end

  # DELETE /nessus_scans/1
  def destroy
    @nessus_scan.destroy
    respond_with(@nessus_scan)
  end

  # get current list of nessus scans
  def update_list
    Nessus::ListScansJob.perform_now
    flash[:notice] = "list update done"
    redirect_to nessus_scans_path
  end

  # import a nessus scan
  def import
    Nessus::ImportScansJob.perform_later(nessus_id: @nessus_scan.nessus_id)
    flash[:notice] = "Import nessus data started in background; please reload index page a few minutes later"
    redirect_to nessus_scans_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nessus_scan
      @nessus_scan = NessusScan.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def nessus_scan_params
      params.require(:nessus_scan).permit(
        :nessus_id, :uuid, :name, :status, :last_modification_date, 
        :import_state, :import_mode
      )
    end
end
