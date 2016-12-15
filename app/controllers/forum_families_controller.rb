class ForumFamiliesController < ApplicationController
  before_action :set_forum_family, only: [:show]

  before_action :authenticate_employee!, only: [:sort]

  # GET /forum_families
  # GET /forum_families.json
  def index
    @forum_families = current_country.forum_families
  end

  # GET /forum_families/1
  # GET /forum_families/1.json
  def show; end

  # POST /forum_families/sort
  def sort
    unless params[:forum_family].nil?
      params[:forum_family].each .each_with_index do |id, index|
        ForumFamily.update(id, position: index + 1)
      end
    end
    render nothing: true
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_forum_family
    @forum_family = ForumFamily.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def forum_family_params
    params.require(:forum_family).permit(:name, :description, :visual, :country_id, :position)
  end
end
