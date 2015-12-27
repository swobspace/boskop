class LinesController < ApplicationController
  before_action :set_line, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  def search
  end

  # GET /lines
  def index
    @lines = Line.all
    respond_with(@lines)
  end

  # GET /lines/1
  def show
    respond_with(@line)
  end

  # GET /lines/new
  def new
    @line = Line.new
    respond_with(@line)
  end

  # GET /lines/1/edit
  def edit
  end

  # POST /lines
  def create
    @line = Line.new(line_params)

    @line.save
    respond_with(@line)
  end

  # PATCH/PUT /lines/1
  def update
    @line.update(line_params)
    respond_with(@line)
  end

  # DELETE /lines/1
  def destroy
    @line.destroy
    respond_with(@line)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line
      @line = Line.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def line_params
      params.require(:line).permit(:name, :description, :provider_id, :location_a_id, :location_b_id, :access_type_id, :bw_upstream, :bw_downstream, :framework_contract_id, :contract_start, :contract_end, :contract_period, :period_of_notice, :period_of_notice_unit, :renewal_period, :renewal_unit, :line_state_id)
    end
end
