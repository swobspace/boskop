class MacPrefixesController < ApplicationController
  before_action :set_mac_prefix, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /mac_prefixes
  def index
    @mac_prefixes = MacPrefix.all
    respond_with(@mac_prefixes)
  end

  # GET /mac_prefixes/1
  def show
    respond_with(@mac_prefix)
  end

  # GET /mac_prefixes/new
  def new
    @mac_prefix = MacPrefix.new
    respond_with(@mac_prefix)
  end

  # GET /mac_prefixes/1/edit
  def edit
  end

  # POST /mac_prefixes
  def create
    @mac_prefix = MacPrefix.new(mac_prefix_params)

    @mac_prefix.save
    respond_with(@mac_prefix)
  end

  # PATCH/PUT /mac_prefixes/1
  def update
    @mac_prefix.update(mac_prefix_params)
    respond_with(@mac_prefix)
  end

  # DELETE /mac_prefixes/1
  def destroy
    @mac_prefix.destroy
    respond_with(@mac_prefix)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mac_prefix
      @mac_prefix = MacPrefix.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def mac_prefix_params
      params.require(:mac_prefix).permit(:oui, :vendor)
    end
end
