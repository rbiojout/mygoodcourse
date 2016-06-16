class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update, :destroy]


  # GET /families
  # GET /families.json
  def index
    @families = Family.all
  end

  # GET /families/1
  # GET /families/1.json
  def show
  end

  # GET /families/new
  def new
    @family = Family.new
  end

  # GET /families/1/edit
  def edit
  end

  # POST /families
  # POST /families.json
  def create
    @family = Family.new(family_params)

    respond_to do |format|
      if @family.save
        format.html { redirect_to @family, notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @family }
      else
        format.html { render :new }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /families/1
  # PATCH/PUT /families/1.json
  def update
    logger.debug ("===== #{family_params}")
    respond_to do |format|
      if @family.update(family_params)
        format.html { redirect_to @family, notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @family }
      else
        format.html { render :edit }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /families/1
  # DELETE /families/1.json
  def destroy
    @family.destroy
    respond_to do |format|
      format.html { redirect_to families_url, notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end

  # POST /families/sort
  def sort
    unless params[:family].nil?
      params[:family].each .each_with_index do |id, index|
        Family.update(id, position: index+1)
      end
    end
    render nothing:true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family
      @family = Family.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_params
      params.require(:family).permit(:name, :description, :position, categories_attributes: [:id, :name, :description, :position, :_destroy])
    end
end
