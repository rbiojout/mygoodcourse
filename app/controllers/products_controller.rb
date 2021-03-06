class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_customer!, only: [:new, :create, :update, :edit, :destroy, :myproducts]

  before_action :correct_user, except: :show

  helper_method :sort_column, :sort_direction

  # GET /products
  # GET /products.json
  def index
    @products = Product.paginate(page: params[:page], per_page: Product.per_page)
  end

  # GET /catalog
  def catalog
    # retrieve the search query
    # filter only on active products when searching
    query = params[:query]

    query_store = session[:query_store]

    unless query.nil?
      # we add or remove if the parameter is sent
      query_store = if query.empty?
                      nil
                    else
                      query
                    end
    end

    if query_store.nil?
      @products = Product.includes(:attachments).active # creates an anonymous scope
    else
      @products = Product.includes(:attachments).search_by_text(query_store)
      if @products.count.zero?
        @products = Product.active
        flash.now[:alert] = "#{t('dialog.method.no_result_found')} (#{query_store})"
        query_store = nil
      end
    end

    session[:query_store] = query_store

    # select the Cycle, Level, Family, Category associated to the Country
    country_families = current_country.families || Family.first
    country_categories = current_country.categories || Category.first
    country_cycles = current_country.cycles || Cycle.first
    country_levels = current_country.levels || Level.first

    # we need to have data relevant to the country
    # we reset if necessary
    session[:family_for_products_id] ||= []
    session[:family_for_products_id] = session[:family_for_products_id] & country_families.pluck(:id)
    session[:family_for_products_id] = nil if session[:family_for_products_id].count.zero?

    session[:category_for_products_id] ||= []
    session[:category_for_products_id] = session[:category_for_products_id] & country_categories.pluck(:id)
    session[:category_for_products_id] = nil if session[:category_for_products_id].count.zero?

    session[:cycle_for_products_id] ||= []
    session[:cycle_for_products_id] = session[:cycle_for_products_id] & country_cycles.pluck(:id)
    session[:cycle_for_products_id] = nil if session[:cycle_for_products_id].count.zero?

    session[:level_for_products_id] ||= []
    session[:level_for_products_id] = session[:level_for_products_id] & country_levels.pluck(:id)
    session[:level_for_products_id] = nil if session[:level_for_products_id].count.zero?

    # store the country
    # if we change the country we reset all filters
    if current_country.id != session[:current_country_id]
      # family_id = country_families.pluck(:id)
      params[:family_id] = nil
      session[:family_for_products_id] = nil
      # category_id = country_categories.pluck(:id)
      params[:category_id] = nil
      session[:category_for_products_id] = nil

      # cycle_id = country_cycles.pluck(:id)
      params[:cycle_id] = nil
      session[:cycle_for_products_id] = nil
      # level_id = country_levels.pluck(:id)
      params[:level_id] = nil
      session[:level_for_products_id] = nil
    end

    logger.debug("===> #{current_country.name}")
    logger.debug("===> parameters country #{country_families}/#{country_categories.pluck(:id)}/#{country_cycles}/#{country_levels}")

    # normalize parameters to array
    # so we can make diff of arrays
    params[:family_id] = [].push(params[:family_id].to_i) unless params[:family_id].nil? || Array.try_convert(params[:family_id])
    params[:category_id] = [].push(params[:category_id].to_i) unless params[:category_id].nil? || Array.try_convert(params[:category_id])
    params[:cycle_id] = [].push(params[:cycle_id].to_i) unless params[:cycle_id].nil? || Array.try_convert(params[:cycle_id])
    params[:level_id] = [].push(params[:level_id].to_i) unless params[:level_id].nil? || Array.try_convert(params[:level_id])

    # Get the parameters
    # for filtering regarding the Cycle, Level, Family, Category
    # we store the request in the cookies in order to present the level of selection
    # we need a parameter set to '0' in order to erase the selection
    # we initialize with the informations associated to the country if we don't have any information

    logger.debug("===> parameters received #{params[:family_id]}/#{params[:category_id]}/#{params[:cycle_id]}/#{params[:level_id]}")

    family_id = params[:family_id] || session[:family_for_products_id] || country_families.pluck(:id)
    category_id = params[:category_id] || session[:category_for_products_id] || country_categories.pluck(:id)

    logger.debug("===> family used #{family_id} from #{params[:family_id]}/#{session[:family_for_products_id]}/#{country_families.pluck(:id)}")
    logger.debug("===> category used #{category_id} from #{params[:category_id]}/#{session[:category_for_products_id]}/#{country_categories.pluck(:id)}")

    cycle_id = params[:cycle_id] || session[:cycle_for_products_id] || country_cycles.pluck(:id)
    level_id = params[:level_id] || session[:level_for_products_id] || country_levels.pluck(:id)

    logger.debug("===> level_id from #{params[:level_id]}/#{session[:level_for_products_id]}/#{country_levels.pluck(:id)}")

    logger.debug("===> parameters used #{family_id}/#{category_id}/#{cycle_id}/#{level_id}")

    # prepare parameters for Family and Category
    # do we have to delete some parameters?
    # unload if :family_id equal 0
    unless params[:family_id].nil?
      if family_id == [0]
        family_id = country_families.unscope(:order).uniq.pluck(:id) # nil
        session[:family_for_products_id] = nil
      else
        session[:family_for_products_id] = family_id
      end
      category_id = Category.with_products_for_family(family_id).unscope(:order).distinct.pluck(:id)
      session[:category_for_products_id] = category_id
    end
    # unload if :category_id equal 0
    unless params[:category_id].nil?
      if category_id == [0]
        category_id = country_categories.unscope(:order).uniq.pluck(:id) # nil
        session[:category_for_products_id] = nil
        # if we have the category we need to have set the corresponding family
      else
        session[:category_for_products_id] = category_id
        family_id = Category.where(id: category_id).unscope(:order).distinct.pluck(:family_id)
        session[:family_for_products_id] = family_id
      end
    end

    logger.debug("===> parameters corrected #{family_id}/#{category_id}/#{cycle_id}/#{level_id}")

    # prepare parameters for Cycle and Level
    # do we have to delete some parameters?
    # unload if :cycle_id equal 0
    unless params[:cycle_id].nil?
      if cycle_id == [0]
        cycle_id = country_cycles.unscope(:order).uniq.pluck(:id) # nil
        session[:cycle_for_products_id] = nil
      else
        session[:cycle_for_products_id] = cycle_id
      end
      level_id = Level.with_products_for_cycle(cycle_id).unscope(:order).uniq.pluck(:id) # nil
      session[:level_for_products_id] = level_id
    end
    # unload if :level_id equal 0
    unless params[:level_id].nil?
      if level_id == [0]
        level_id = country_levels.unscope(:order).uniq.pluck(:id) # nil
        session[:level_for_products_id] = nil
        # if we have the level we need to have set the corresponding family
      else
        session[:level_for_products_id] = level_id
        # cycle_id = Level.find(level_id).cycle_id
        logger.debug("level_id #{level_id}")
        cycle_id = Level.where(id: level_id).unscope(:order).uniq.pluck(:cycle_id)
        session[:cycle_for_products_id] = cycle_id
      end
    end

    logger.debug("===> parameters corrected pass 2 #{family_id}/#{category_id}/#{cycle_id}/#{level_id}")

    # add the corresponding families, categories, cycles and levels
    query_families = Family.associated_to_query(query_store)
    query_categories = Category.associated_to_query(query_store)
    # we want the common values from all filters
    selected_families = Family.all
    selected_families = Array(Family.find(family_id)) unless family_id.empty?
    selected_categories = Category.all
    selected_categories = Array(Category.find(category_id)) unless category_id.empty?
    @families = (selected_families & query_families & Family.associated_to_cycles_levels(cycle_id, level_id, true))
    @categories = (selected_categories & query_categories & Category.associated_to_cycles_levels(cycle_id, level_id, true))

    # store the Families and Categories
    # session[:family_for_products_id] = @families.map(&:id)
    # session[:category_for_products_id] = @categories.map(&:id)
    # we filter at the lowest level
    @products = @products.for_category(@categories.map(&:id))

    logger.debug("?? #{@categories}/#{@products}")

    # add the corresponding families, categories, cycles and levels
    query_cycles = Cycle.associated_to_query(query_store)
    query_levels = Level.associated_to_query(query_store)
    # we want the common values from all filters

    selected_cycles = Cycle.all
    selected_cycles = Array(Cycle.find(cycle_id)) unless cycle_id.empty?
    selected_levels = Level.all
    selected_levels = Array(Level.find(level_id)) unless level_id.empty?
    @cycles = (selected_cycles & query_cycles & Cycle.associated_to_families_categories(family_id, category_id, true))
    @levels = (selected_levels & query_levels & Level.associated_to_families_categories(family_id, category_id, true))

    logger.debug("+++ #{country_levels.map(&:id)}/#{query_levels.map(&:id)}/#{Level.associated_to_families_categories(family_id, category_id, true).map(&:id)}")

    # store the Cycles and Levels
    # session[:cycle_for_products_id] = @cycles.map(&:id)
    # session[:level_for_products_id] = @levels.map(&:id)
    # we filter at the lowest level
    @products = @products.for_level(@levels.map(&:id))

    # @TODO if after all filter in combination to the search, we should take all product and add a flash alert
    @products = @products.unscope(:order).order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: Product.per_page)
  end

  # GET /myproducts
  def myproducts
    @products = current_customer.products.order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: Product.per_page)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @attachments = @product.attachments
    @reviews = @product.reviews.paginate(page: params[:page], per_page: PAGINATE_PAGES)
    # follow activity on pages
    # we keep track of the current customer in impressions
    @current_user = current_customer
    impressionist(@product)
  end

  # GET /products/new
  def new
    # @product = Product.new
    @product = current_customer.products.new
    @product.attachments.build
  end

  # GET /products/1/edit
  def edit; end

  # POST /products
  # POST /products.json
  def create
    # @product = Product.new(product_params)
    @product = current_customer.products.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @product }
      else
        @product.attachments.build if @product.attachments.empty?
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
        format.html { redirect_to @product, notice: t('views.flash_update_message') }
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
      format.html { redirect_to products_url, notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end

  # POST /buy_product
  # POST /buy_product json
  def add_to_basket
    # if the customer is not signed, we can not check if an order has been already made
    #  it is checked during the confirmation state
    product_to_order = Product.friendly.find(params[:product_id])
    if product_to_order.nil? || !product_to_order.active?
      flash[:alert] = t('dialog.shop.alert_add_cart')
    else
      current_order.order_items.add_item(product_to_order)
      flash[:notice] = t('dialog.shop.notice_add_cart')
    end

    respond_to do |format|
      format.html { redirect_to catalog_products_path }
      format.json { render json: {added: true} }
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:name, :sku, :permalink, :description, :active, :price,
                                    attachments_attributes: [:file, :file_cache, :file_size, :file_type, :nbpages, :version_number, :active, :_destroy, :id],
                                    category_ids: [], level_ids: [])
  end

  def correct_user
    redirect_to products_path, alert: t('dialog.restricted') unless @product.nil? || @product.customer_id == current_customer.id
  end

  # Used for sorting the list
  def sort_column
    Product.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def check_attachment
    # logger.debug "@product.attachments.length #{@product.attachments.length}  #{@product.attachments.first} #{params[:product][:attachments_attributes]["0"][:_destroy] == 'true'}"
    if params[:product][:attachments_attributes].nil?
      # @product.attachments.build
      flash[:alert] = t('dialog.product.alert_need_attachment')
      # redirect_to product_path
      logger.debug 'no attachment'
    else if params[:product][:attachments_attributes].size == 1 && params[:product][:attachments_attributes].first[1][:_destroy] == 'true'
           params[:product][:attachments_attributes].first[1][:_destroy] = 'false'
           flash[:alert] = t('dialog.product.alert_need_attachment')
       # redirect_to product_path
         end

    end
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    stat
  end
end
