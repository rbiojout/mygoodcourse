class FamiliesController < ApplicationController
  before_action :set_family, only: [:show]

  before_action :authenticate_employee!, except: [:index, :show]

  # GET /families
  # GET /families.json
  def index
    @families = Family.all
  end

  # GET /families/1
  # GET /families/1.json
  def show; end

  # POST /families/sort
  def sort
    unless params[:family].nil?
      params[:family].each .each_with_index do |id, index|
        Family.update(id, position: index + 1)
      end
    end
    render nothing: true
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_family
    @family = Family.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def family_params
    params.require(:family).permit(:name, :description, :position, :country_id, categories_attributes: [:id, :name, :description, :position, :_destroy])
  end
end
