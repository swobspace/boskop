class SoftwareRawDataController < ApplicationController
  before_action :set_software_raw_datum, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /software_raw_data
  def index
    @software_raw_data = SoftwareRawDatum.all
    respond_with(@software_raw_data)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_software_raw_datum
      @software_raw_datum = SoftwareRawDatum.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def software_raw_datum_params
      params.require(:software_raw_datum).permit(:software_id, :name, :version, :vendor, :count, :operation_system, :lastseen, :source)
    end
end
