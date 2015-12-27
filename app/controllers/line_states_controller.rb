class LineStatesController < ApplicationController
  before_action :set_line_state, only: [:show, :edit, :update, :destroy]
  before_action :add_breadcrumb_show, only: [:show]

  # GET /line_states
  def index
    @line_states = LineState.all
    respond_with(@line_states)
  end

  # GET /line_states/1
  def show
    respond_with(@line_state)
  end

  # GET /line_states/new
  def new
    @line_state = LineState.new
    respond_with(@line_state)
  end

  # GET /line_states/1/edit
  def edit
  end

  # POST /line_states
  def create
    @line_state = LineState.new(line_state_params)

    @line_state.save
    respond_with(@line_state)
  end

  # PATCH/PUT /line_states/1
  def update
    @line_state.update(line_state_params)
    respond_with(@line_state)
  end

  # DELETE /line_states/1
  def destroy
    @line_state.destroy
    respond_with(@line_state)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_state
      @line_state = LineState.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def line_state_params
      params.require(:line_state).permit(:name, :description, :active)
    end
end
