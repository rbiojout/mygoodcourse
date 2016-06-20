class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy, :dashboard]
  before_action :authenticate_customer!, only: [:update, :edit, :dashboard]

  before_action :correct_user, only: [:update, :edit]

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.all
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # GET /customers/dashboard
  def dashboard

  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    begin
      @customer.destroy
      respond_to do |format|
        format.html { redirect_to customers_url, notice: t('views.flash_delete_message') }
        format.json { head :no_content }
      end
    rescue
      flash[:msg] = "Can't delete"
      respond_to do |format|
        format.html { redirect_to(root_path, error: "Can't delete") }
        format.xml  { head :ok }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :first_name, :email, :password, :password_confirmation, :language, :country_id, :mobile, :birthdate, :picture, :picture_cache, :formatted_address, :street_address, :administrative_area_level_1,  :administrative_area_level_2, :postal_code, :locality, :lat, :lng)
    end

    def correct_user
      @customer = Customer.find(params[:id])
      redirect_to root_path, alert: t('dialog.restricted') unless @customer == current_customer
    end
end
