class HostsController < ApplicationController
  before_action :set_host, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /hosts
  def index
    @hosts = Host.left_outer_joins(:location, :host_category, :operating_system, :merkmale).distinct
    @merkmalklassen = Merkmalklasse.includes(:merkmale).visibles(:host, 'index')
    respond_with(@hosts) do |format|
      format.json { render json: HostsDatatable.new(@hosts, view_context) }
    end
  end

  def search
    @hosts = Host.left_outer_joins(:location, :host_category, :operating_system, :merkmale).distinct
    @merkmalklassen = Merkmalklasse.includes(:merkmale).visibles(:host, 'index')
    query = HostQuery.new(@hosts, search_params)
    @filter_info = query.search_options
    @hosts = query.all
    respond_with(@hosts) do |format|
      format.csv {
        authorize! :csv, Host
        send_data @hosts.to_csv(col_sep: "\t"),
                  filename: 'Hosts.csv'
      }
    end

  end

  # GET /hosts/1
  def show
    respond_with(@host)
  end

  # GET /hosts/new
  def new
    @host = Host.new
    merkmale
    respond_with(@host)
  end

  # GET /hosts/1/edit
  def edit
    merkmale
  end

  # POST /hosts
  def create
    @host = Host.new(host_params)

    @host.save
    respond_with(@host)
  end

  # PATCH/PUT /hosts/1
  def update
    @host.update(host_params)
    respond_with(@host)
  end

  # DELETE /hosts/1
  def destroy
    @host.destroy
    respond_with(@host)
  end

  def new_import
  end

  def import
    type = params[:type]
    if type == 'csv'
      result = ImportCsvHostsService.new(import_params).call
    elsif type == 'xml'
      result = ImportNmapXmlService.new(import_params).call
    else
      flash[:notice] = "Import format #{type} not yet implemented"
      redirect_to import_hosts_path
      return
    end
    if result.success?
      flash[:success] = "Import successful"
      redirect_to hosts_path
    else
      flash[:error] = result.error_message.to_s
      redirect_to hosts_path
    end
  end

  def eol_summary
    eol_ids = OperatingSystem.where("eol < ?", Date.today).pluck(:id)
    hosts = Host.where("lastseen > ? AND operating_system_id IN (?)", 
                        1.month.before(Date.today), eol_ids)
    @hosts = hosts.
      joins(:operating_system, :location).
      select("count(hosts.id) as count, operating_systems.name, locations.lid").
      group("operating_systems.name, locations.lid")
  end

  def vuln_risk_matrix
    @matrix = Host.vuln_risk_matrix
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_host
      @host = Host.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def host_params
      params.require(:host).permit(
        :name, :description, :ip, :cpe, :raw_os, :operating_system_id,
        :lastseen, :mac, :host_category_id, :location_id, :fqdn,
        :workgroup, :domain_dns, :vendor,  :serial, :uuid, :product,
        :warranty_sla, :warranty_start, :warranty_end,
        [ merkmale_attributes:
          [ :id, :value, :merkmalklasse_id, :_destroy ],
        ]
      )
    end

    def import_params
      params.permit(:utf8, :authenticity_token, :type, :file, :update).to_hash
    end

    def search_params
        # see class HostQuery for possible options
        searchparms = params.permit(*submit_parms,
          :name, :description, :ip, :operating_system, :cpe, :raw_os, :serial,
          :fqdn, :domain_dns, :workgroup, :lastseen, :newer, :older, :current, 
          :uuid, :product, :warranty_start_from, :warranty_start_until,
          :mac, :vendor, :host_category, :lid, :eol, :vuln_risk, :limit).to_hash
      {limit: 100}.merge(searchparms).reject{|k, v| (v.blank? || submit_parms.include?(k))}
    end

    def submit_parms
      [ "utf8", "authenticity_token", "commit", "format" ]
    end

    def merkmale
      merkmale = @host.merkmale.to_a
      exists    = merkmale.map {|m| m.merkmalklasse.id}
      klassen   = Merkmalklasse.where(for_object: Host.to_s)
      klassen.each do |kl|
        unless exists.include?(kl.id)
          @host.merkmale.build(merkmalklasse_id: kl.id)
        end
      end
    end

end
