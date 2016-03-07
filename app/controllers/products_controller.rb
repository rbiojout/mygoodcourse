class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_customer!, only: [:new, :create, :update, :edit, :destroy]

  before_action :correct_user, except: :show


  helper_method :sort_column, :sort_direction

  # GET /products
  # GET /products.json
  def index
    @products = Product.order(sort_column + " " + sort_direction)
  end


  # GET /products
  # GET /products.json
  def myproducts
    @products = current_customer.products.order( sort_column + " " + sort_direction).paginate(page: params[:page], :per_page => 30)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @attachments = @product.attachments
  end

  # GET /products/new
  def new
    #@product = Product.new
    @product = current_customer.products.new
    @product.attachments.build
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    #@product = Product.new(product_params)
    @product = current_customer.products.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_to_basket
    #begin
      product_to_order = Product.find(params[:product_id])
      if (product_to_order.nil? || !product_to_order.active?)
        flash[:alert] = "Product not active."
      else
        current_order.order_items.add_item(product_to_order)
        flash[:notice] = "Product was successfully added."
      end


    respond_to do |wants|
      wants.html { redirect_to request.referer }
      wants.json { render :json => {:added => true} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :sku, :permalink, :description, :short_description, :active, :price, attachments_attributes: [:file, :file_cache, :file_size, :file_type, :nbpages, :version_number, :active, :_destroy, :id], :category_ids => [])
    end

    def correct_user
      redirect_to products_path, alert: "You don't have the right to access to this page" unless @product.nil? || @product.customer_id == current_customer.id
    end

    # Used for sorting the list
    def sort_column
      Product.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def check_attachment
      #logger.debug "@product.attachments.length #{@product.attachments.length}  #{@product.attachments.first} #{params[:product][:attachments_attributes]["0"][:_destroy] == 'true'}"
      if ( params[:product][:attachments_attributes].nil? )
        #@product.attachments.build
        flash[:error] = "You need to provide an attachment"
        #redirect_to product_path
        logger.debug "no attachment"
      else if (params[:product][:attachments_attributes].size == 1 && params[:product][:attachments_attributes].first[1][:_destroy] == 'true')
             params[:product][:attachments_attributes].first[1][:_destroy] = 'false'
         flash[:error] = "You need to provide an attachment"
         #redirect_to product_path
       end

    end
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
      stat
    end
end
