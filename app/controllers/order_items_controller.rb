class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:update, :destroy]

  # GET /countries
  # GET /countries.json
  def index
    @order = current_order
    @order_items = current_order.order_items
  end



  # POST /order_items
  # POST /order_items.json
  def create
    @order = current_order
    @order_item = @order.order_items.new(order_item_params)
    @order.save
    session[:order_id] = @order.id
    render nothing:true

    #@order_item = OrderItems.new(order_item_params)
    #respond_to do |format|
    #  if @order_item.save
    #    format.html { redirect_to @order_item, notice: 'Order item was successfully created.' }
    #    format.json { render :show, status: :created, location: @order_item }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @order_item.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /order_items/1
  # PATCH/PUT /order_items/1.json
  def update
    @order_item.update_attributes(order_item_params)
    render nothing:true

    #respond_to do |format|
    #  if @order_item.update(order_item_params)
    #    format.html { redirect_to @order_item, notice: 'Order item was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @order_item }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @order_item.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  def delete
    @order_item = OrderItem.find(params[:order_item_id])
  end

  # DELETE /order_items/1
  # DELETE /order_items/1.json
  def destroy
    @order_item.destroy
    @order_items = current_order.order_items
    #respond_to do |format|
    #  format.html { redirect_to order_items_url, notice: 'Order item was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
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
