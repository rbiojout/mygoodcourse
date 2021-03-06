class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy, :dashboard, :circle, :wishlist, :reviews_list]
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
    @products = @customer.products.active.paginate(page: params[:page], per_page: Product.per_page) unless @customer.nil?
    # follow activity on pages
    # we keep track of the current customer in impressions
    @current_user = current_customer
    impressionist(@customer)
  end

  # additionnal page for show
  # give all the followers and followeds
  # GET /customers/:id/circle
  def circle
    @followers = @customer.followers
    @followeds = @customer.followeds
    # follow activity on pages
    # we keep track of the current customer in impressions
    @current_user = current_customer
    impressionist(@customer)
  end

  # GET /customers/1/edit
  def edit; end

  # GET /customers/:id/dashboard
  def dashboard; end

  # GET /customers/:id//whislist
  def wishlist
    @products = @customer.wish_products
  end

  # GET /customers/:id//reviewlist
  def reviews_list
    @reviews = Review.find_for_all_product_of_customer(@customer.id)
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
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to catalog_products_path, notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  rescue
    flash[:msg] = "Can't delete"
    respond_to do |format|
      format.html { redirect_to(catalog_products_path, error: "Can't delete") }
      format.xml  { head :ok }
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = Customer.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params.require(:customer).permit(:name, :first_name, :email, :password, :password_confirmation, :language, :country_id, :mobile, :birthdate, :picture, :picture_cache, :formatted_address, :street_address, :administrative_area_level_1, :administrative_area_level_2, :postal_code, :locality, :lat, :lng, :description, :terms_of_service)
  end

  def correct_user
    @customer = Customer.friendly.find(params[:id])
    redirect_to catalog_products_path, alert: t('dialog.restricted') unless @customer == current_customer
  end
end
