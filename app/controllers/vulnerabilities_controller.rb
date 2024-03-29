class VulnerabilitiesController < ApplicationController
  before_action :set_vulnerability, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /vulnerabilities
  def index
    if @host
      @filter_info = { host_id: @host.id, current: 1 }
      @filter_params = { current: 1 }
      @vulnerabilities = @host.vulnerabilities.left_outer_joins(:vulnerability_detail, host: [:host_category, :location, :operating_system])
    else
      @filter_info = { current: 1, higher: 1 }
      @filter_params = { current: 1, higher: 1 }
      @vulnerabilities = Vulnerability.current.higher.left_outer_joins(:vulnerability_detail, host: [:host_category, :location, :operating_system])
    end
    respond_with(@vulnerabilities) do |format|
      format.json { render json: VulnerabilitiesDatatable.new(@vulnerabilities, view_context, @filter_params) }
    end
  end

  def search
    @vulnerabilities = Vulnerability.left_outer_joins(:vulnerability_detail, host: [:host_category, :location, :operating_system])
    query = VulnerabilityQuery.new(@vulnerabilities, search_params)
    @filter_info = query.search_options
    @vulnerabilities = query.all
    add_breadcrumb(t('boskop.search_vulnerabilities'),
                   search_vulnerabilities_path(search_params))
    respond_with(@vulnerabilities) do |format|
      format.csv {
        authorize! :csv, Vulnerability
        send_data @vulnerabilities.to_csv(col_sep: "\t"),
                  filename: 'vulnerabilities.csv'
      }
    end
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
    type = params[:type]
    if type == 'nessus'
      result = ImportNessusVulnerabilitiesService.new(import_params).call
    elsif type == 'openvas'
      result = ImportOpenVASVulnerabilitiesService.new(import_params).call
    else
      flash[:notice] = "Import format #{type} not yet implemented"
      redirect_to import_vulnerabilities_path
      return
    end
    if result.success?
      flash[:success] = "Import successful"
      redirect_to vulnerabilities_path
    else
      flash[:error] = result.error_message.to_s
      redirect_to vulnerabilities_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vulnerability
      @vulnerability = Vulnerability.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def vulnerability_params
      params.require(:vulnerability).permit(:host_id, :vulnerability_detail_id,
                                            :plugin_output, :lastseen)
    end

    def import_params
      params.permit(:utf8, :authenticity_token, :type, :file).to_hash
    end

   def search_params
        # see VulnerabilityQuery for possible options
        searchparms = params.permit(*submit_parms,
          :name, :severity, :ip, :operating_system, :plugin_output, :nvt,
          :hostname, :host_category, :critical, :current,
          :created_at, :created_newer, :created_older,
          :lastseen, :newer, :older, :current, :lid, :limit,
          :threat,
          threats: [],
          lid: [],
        ).to_hash
      {"limit" => 100}.merge(searchparms).reject{|k, v| (v.blank? || submit_parms.include?(k))}
    end

    def submit_parms
      [ "utf8", "authenticity_token", "commit", "format" ]
    end

end
