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

  # GET /catalog
  def catalog
    # filter only on active products
    @products = Product.active # creates an anonymous scope

    @products = @products.status(params[:status]) if params[:status].present?

    # Get the parameters
    family_id = params[:family_id] || session[:family_for_products_id]
    category_id = params[:category_id] || session[:category_for_products_id]

    cycle_id = params[:cycle_id] || session[:cycle_for_products_id]
    level_id = params[:level_id] || session[:level_for_products_id]


    # prepare parameters for Family and Category
    # do we have to delete some parameters?
    # unload if :family_id equal 0
    unless params[:family_id].nil?
      if family_id.to_s == "0"
        session[:family_for_products_id] = nil
        family_id =nil
      end
      session[:category_for_products_id] = nil
      category_id = nil
      #logger.debug("=====> .. #{category_id}")
    end
    # unload if :category_id equal 0
    unless category_id.nil?
      if category_id.to_s == "0"
        session[:category_for_products_id] = nil
        category_id =nil
        # if we have the category we need to have set the corresponding family
      else
        session[:category_for_products_id] = category_id
        family_id = Category.find(category_id).family_id
        session[:family_for_products_id] = family_id
      end
    end


    # prepare parameters for Cycle and Level
    # do we have to delete some parameters?
    # unload if :cycle_id equal 0
    unless params[:cycle_id].nil?
      if cycle_id.to_s == "0"
        session[:cycle_for_products_id] = nil
        cycle_id =nil
      end
      session[:level_for_products_id] = nil
      level_id = nil
    end
    # unload if :level_id equal 0
    unless level_id.nil?
      if level_id.to_s == "0"
        session[:level_for_products_id] = nil
        level_id =nil
        # if we have the level we need to have set the corresponding family
      else
        session[:level_for_products_id] = level_id
        cycle_id = Level.find(level_id).cycle_id
        session[:cycle_for_products_id] = cycle_id
      end
    end


    # filter for Family and Category
    # show the most detailed level of information
    unless family_id.nil?
      unless category_id.nil?
        @products.for_category(category_id)
        # store the category in session
        session[:category_for_products_id] = category_id
        # store the family in session
        session[:family_for_products_id] = family_id
      else
        @products = @products.for_family(family_id)
        # store the family in session
        session[:family_for_products_id] = family_id
      end
    end

    # filter for Cycle and Level
    # show the most detailed level of information
    unless cycle_id.nil?
      unless level_id.nil?
        @products.for_level(level_id)
        # store the level in session
        session[:level_for_products_id] = level_id
        # store the cycle in session
        session[:cycle_for_products_id] = cycle_id
      else
        @products = @products.for_cycle(cycle_id)
        # store the cycle in session
        session[:cycle_for_products_id] = cycle_id
      end
    end

    logger.debug("===> #{sort_column} / #{sort_direction}")
    @products = @products.active.order( sort_column + " " + sort_direction)

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
      params.require(:product).permit(:name, :sku, :permalink, :description, :short_description, :active, :price,
                                      attachments_attributes: [:file, :file_cache, :file_size, :file_type, :nbpages, :version_number, :active, :_destroy, :id],
                                      :category_ids => [], :level_ids => [])
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
