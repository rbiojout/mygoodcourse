class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:update, :delete, :destroy]

  # http://www.benkirane.ch/ajax-bootstrap-modals-rails/

  # GET /order_items
  # GET /order_items.json
  def index
    @order = current_order
    @order_items = current_order.order_items
    @products = current_order.products
  end

  # POST /order_items
  # POST /order_items.json
  def create
    @order = current_order
    @order_item = @order.order_items.new(order_item_params)
    if @order.save
      session[:order_id] = @order.id
    end
    render nothing: true

    # @order_item = OrderItems.new(order_item_params)
    # respond_to do |format|
    #  if @order_item.save
    #    format.html { redirect_to @order_item, notice: 'Order item was successfully created.' }
    #    format.json { render :show, status: :created, location: @order_item }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @order_item.errors, status: :unprocessable_entity }
    #  end
    # end
  end

  # POST /order_items/undo?product_id=
  def undo
    product_to_order = Product.find(params[:product_id])
    @order_item = current_order.order_items.add_item(product_to_order)
    respond_to do |format|
      format.html { redirect_to catalog_products_path }
      format.js {}
    end
  end

  # PATCH/PUT /order_items/1
  # PATCH/PUT /order_items/1.json
  def update
    @order_item.update_attributes(order_item_params)
    render nothing: true

    # respond_to do |format|
    #  if @order_item.update(order_item_params)
    #    format.html { redirect_to @order_item, notice: 'Order item was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @order_item }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @order_item.errors, status: :unprocessable_entity }
    #  end
    # end
  end

  # DELETE /order_items/1
  # DELETE /order_items/1.json
  def destroy
    @order_item.destroy
    @order_items = current_order.order_items
    if @order_items.empty?
      # empty session cart
      session[:order_id] = nil
      respond_to do |format|
        format.html { redirect_to catalog_products_path, flash: {alert: t('dialog.shop.alert_empty_cart')} }
        format.js { render js: "window.location='#{catalog_products_path}'", flash: {alert: t('dialog.shop.alert_empty_cart')} }
      end
    else
      respond_to do |format|
        format.html { redirect_to order_items_path, notice: t('views.flash_delete_message') }
        format.json { head :no_content }
        format.js {}
      end
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_item_params
    params.require(:order_item).permit(:product_id, :price, :tax_rate, :tax_amount, :order_id)
  end
end
