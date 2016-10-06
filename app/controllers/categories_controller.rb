class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  before_action :authenticate_employee!, except: [:index, :show]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end


  def sort
    unless params[:category].nil?
      params[:category].each .each_with_index do |id, index|
        Category.update(id, position: index+1)
      end
    end
    render nothing:true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :description, :family_id)
    end
end
