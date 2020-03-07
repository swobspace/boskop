class SoftwareRawDataController < ApplicationController
  before_action :set_software_raw_datum, only: [:show, :edit, :update, :destroy, 
                                                :add_software]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /software_raw_data
  def index
    @software_raw_data = SoftwareRawDatum.all
    respond_with(@software_raw_data) do |format|
      format.json { 
        render json: SoftwareRawDataDatatable.new(@software_raw_data, view_context) }
    end
  end

  def search
    query = SoftwareRawDataQuery.new(@software_raw_data, search_params)
    @filter_info = query.search_options
    @software_raw_data = query.all
    add_breadcrumb(t('boskop.search_software_raw_data'), 
                   search_software_raw_data_path(search_params))
    respond_with(@software_raw_data) do |format|
      format.csv { raise RuntimeError, "not yet implemented" }
    end
  end

  # GET /software_raw_data/1
  def show
    respond_with(@software_raw_datum)
  end

  # GET /software_raw_data/new
  def new
    @software_raw_datum = SoftwareRawDatum.new
    respond_with(@software_raw_datum)
  end

  # GET /software_raw_data/1/edit
  def edit
  end

  # POST /software_raw_data
  def create
    @software_raw_datum = SoftwareRawDatum.new(software_raw_datum_params)

    @software_raw_datum.save
    respond_with(@software_raw_datum)
  end

  # PATCH/PUT /software_raw_data/1
  def update
    @software_raw_datum.update(software_raw_datum_params)
    respond_with(@software_raw_datum)
  end

  # DELETE /software_raw_data/1
  def destroy
    @software_raw_datum.destroy
    respond_with(@software_raw_datum)
  end

  def new_import
  end

  def import
    result = SoftwareRawData::ImportCsvService.new(import_params).call
    if result.success?
      flash[:success] = "Import successful"
      redirect_to software_raw_data_path
    else
      flash[:error] = result.error_message.to_s
      redirect_to software_raw_data_path
    end
  end

  def add_software
    @software = Software.new(
                  name: @software_raw_datum.name,
                  vendor: @software_raw_datum.vendor,
                  minimum_allowed_version: @software_raw_datum.version,
                  pattern: {
                    "name" => @software_raw_datum.name,
                    "vendor" => @software_raw_datum.vendor,
                    "operating_system" => @software_raw_datum.operating_system,
                  }
                )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_software_raw_datum
      @software_raw_datum = SoftwareRawDatum.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def software_raw_datum_params
      params.require(:software_raw_datum).permit(:software_id, :name, :version, :vendor, :count, :operating_system, :lastseen, :source)
    end

    def import_params
      params.permit(:utf8, :authenticity_token, :file, :source, :lastseen).to_hash
    end

    def search_params
      searchparms = params.permit(*submit_parms,
        :software_id, :use_pattern, :name, :vendor, :operating_system,
        :no_software_id, :lastseen, :newer, :older, :limit).to_hash
      searchparms.reject{|k, v| (v.blank? || submit_parms.include?(k))}
    end

end
