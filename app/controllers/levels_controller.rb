class LevelsController < ApplicationController
  before_action :set_level, only: [:show]

  before_action :authenticate_employee!, except: [:index, :show]

  # GET /levels
  # GET /levels.json
  def index
    @levels = Level.all
  end

  # GET /levels/1
  # GET /levels/1.json
  def show; end

  def sort
    unless params[:level].nil?
      params[:level].each .each_with_index do |id, index|
        Level.update(id, position: index + 1)
      end
    end
    render nothing: true
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_level
    @level = Level.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def level_params
    params.require(:level).permit(:name, :description, :position, :cycle_id)
  end
end
