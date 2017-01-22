class CyclesController < ApplicationController
  before_action :set_cycle, only: [:show]

  before_action :authenticate_employee!, except: [:index, :show]

  # GET /cycles
  # GET /cycles.json
  def index
    @cycles = Cycle.all
  end

  # GET /cycles/1
  # GET /cycles/1.json
  def show; end

  # POST /cycles/sort
  def sort
    unless params[:cycle].nil?
      params[:cycle].each .each_with_index do |id, index|
        Cycle.update(id, position: index + 1)
      end
    end
    head :ok
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_cycle
    @cycle = Cycle.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cycle_params
    params.require(:cycle).permit(:name, :description, :position, :country_id, levels_attributes: [:id, :name, :description, :position, :_destroy])
  end
end
