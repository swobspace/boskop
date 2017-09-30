class VulnerabilitiesController < ApplicationController
  before_action :set_vulnerability, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /vulnerabilities
  def index
    @vulnerabilities = Vulnerability.all
    respond_with(@vulnerabilities)
  end

  # GET /vulnerabilities/1
  def show
    respond_with(@vulnerability)
  end

  # GET /vulnerabilities/new
  def new
    @vulnerability = Vulnerability.new
    respond_with(@vulnerability)
  end

  # GET /vulnerabilities/1/edit
  def edit
  end

  # POST /vulnerabilities
  def create
    @vulnerability = Vulnerability.new(vulnerability_params)

    @vulnerability.save
    respond_with(@vulnerability)
  end

  # PATCH/PUT /vulnerabilities/1
  def update
    @vulnerability.update(vulnerability_params)
    respond_with(@vulnerability)
  end

  # DELETE /vulnerabilities/1
  def destroy
    @vulnerability.destroy
    respond_with(@vulnerability)
  end

  def new_import
  end

  def import
    render body: "not yet implemented"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vulnerability
      @vulnerability = Vulnerability.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def vulnerability_params
      params.require(:vulnerability).permit(:host_id, :vulnerability_detail_id, :lastseen)
    end
end
