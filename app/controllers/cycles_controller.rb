class CyclesController < ApplicationController
  before_action :set_cycle, only: [:show, :edit, :update, :destroy]

  # GET /cycles
  # GET /cycles.json
  def index
    @cycles = Cycle.all
  end

  # GET /cycles/1
  # GET /cycles/1.json
  def show
  end

  # GET /cycles/new
  def new
    @cycle = Cycle.new
  end

  # GET /cycles/1/edit
  def edit
  end

  # POST /cycles
  # POST /cycles.json
  def create
    @cycle = Cycle.new(cycle_params)

    respond_to do |format|
      if @cycle.save
        format.html { redirect_to @cycle, notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @cycle }
      else
        format.html { render :new }
        format.json { render json: @cycle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cycles/1
  # PATCH/PUT /cycles/1.json
  def update
    respond_to do |format|
      if @cycle.update(cycle_params)
        format.html { redirect_to @cycle, notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @cycle }
      else
        format.html { render :edit }
        format.json { render json: @cycle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cycles/1
  # DELETE /cycles/1.json
  def destroy
    @cycle.destroy
    respond_to do |format|
      format.html { redirect_to cycles_url, notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end


  # POST /cycles/sort
  def sort
    unless params[:cycle].nil?
      params[:cycle].each .each_with_index do |id, index|
        Cycle.update(id, position: index+1)
      end
    end
    render nothing:true
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
