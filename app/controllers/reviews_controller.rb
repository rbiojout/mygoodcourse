class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_customer!, only: [:new, :create, :update, :edit, :destroy]

  before_action :correct_user, excep: [:index, :show]

  # GET /reviews
  # GET /reviews.json
  def index
    if params[:product_id].nil?
      @reviews = Review.all
    else
      @reviews.product = Product.find(params[:product_id])
    end
    @reviews = @reviews.paginate(page: params[:page], per_page: PAGINATE_PAGES)
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show; end

  # GET /reviews/new
  def new
    @review = Review.new
    @review.customer = current_customer
    @review.product = Product.find(params[:product_id]) unless params[:product_id].nil?
  end

  # GET /reviews/1/edit
  def edit; end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)
    @review.customer = current_customer
    @nb_reviews = @review.product.nb_reviews

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @review }
        # added
        format.js   { @current_review = @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
        # added
        format.js   { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @review }
        # added
        format.js   { @current_review = @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
        # added
        format.js   { @current_review = @review }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = Review.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def review_params
    params.require(:review).permit(:title, :description, :score, :product_id)
  end

  def correct_user
    redirect_to catalog_products_path, alert: t('dialog.restricted') unless @review.nil? || @review.product.customer_id == current_customer.id
  end
end
