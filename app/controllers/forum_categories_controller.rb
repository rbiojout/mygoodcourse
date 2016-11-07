class ForumCategoriesController < ApplicationController
  before_action :set_forum_category, only: [:show]

  before_action :authenticate_employee!, only: [:sort]

  # GET /forum_categories
  # GET /forum_categories.json
  def index
    @forum_categories = ForumCategory.all
  end

  # GET /forum_categories/1
  # GET /forum_categories/1.json
  def show
    @forum_subjects = @forum_category.forum_subjects.paginate(page: params[:page], :per_page => PAGINATE_PAGES)
  end

  # POST /forum_categories/sort
  def sort
    unless params[:forum_category].nil?
      params[:forum_category].each .each_with_index do |id, index|
        ForumCategory.update(id, position: index+1)
      end
    end
    render nothing:true
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum_category
      @forum_category = ForumCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forum_category_params
      params.require(:forum_category).permit(:name, :description, :visual, :forum_family_id, :position)
    end
end
