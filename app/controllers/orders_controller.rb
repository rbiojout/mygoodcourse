class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all.paginate(page: params[:page], :per_page => 30)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @order.order_items.build()
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    Order.transaction do
      @order = Order.new(order_params)
      @order.status = 'confirming'
    end

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def accept
    @order.accept!(current_customer)
    redirect_to @order, flash: { notice: 'shoppe.orders.accept_notice' }
  rescue Errors::PaymentDeclined => e
    redirect_to @order, flash: { alert: e.message }
  end

  def reject
    @order.reject!(current_customer)
    redirect_to @order, flash: { notice: 'shoppe.orders.reject_notice' }
  rescue Errors::PaymentDeclined => e
    redirect_to @order, flash: { alert: e.message }
  end

  def ship
    @order.ship!(params[:consignment_number], current_customer)
    redirect_to @order, flash: { notice: 'shoppe.orders.ship_notice' }
  end


  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:customer_id, :notes,  order_item_attributes: [:id, :product_id, :price, :tax_rate, :tax_amount, :_destroy])
    end
end
