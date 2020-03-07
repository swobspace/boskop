class SoftwareController < ApplicationController
  before_action :set_software, only: [:show, :edit, :update, :destroy, :assign_raw_software]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /software
  def index
    @software = Software.all
    respond_with(@software)
  end

  # GET /software/1
  def show
    respond_with(@software)
  end

  # GET /software/new
  def new
    @software = Software.new
    respond_with(@software)
  end

  # GET /software/1/edit
  def edit
  end

  # POST /software
  def create
    @software = Software.new(software_params)

    @software.save
    respond_with(@software)
  end

  # PATCH/PUT /software/1
  def update
    @software.update(software_params)
    respond_with(@software)
  end

  # DELETE /software/1
  def destroy
    @software.destroy
    respond_with(@software)
  end

  def assign_raw_software
    AssignSoftwareJob.perform_now(software_id: @software.id)
    redirect_to(@software)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_software
      @software = Software.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def software_params
      parms = params.require(:software)
                    .permit(:name, :vendor, :description, 
                            :minimum_allowed_version, :maximum_allowed_version, 
                            :green, :yellow, :red, :software_category_id,
                            pattern: Software::PATTERN_ATTRIBUTES)
      if parms['pattern'].present?
        parms['pattern'] = parms['pattern'].reject {|k,v| v.blank? }
      end
      parms
    end
end
