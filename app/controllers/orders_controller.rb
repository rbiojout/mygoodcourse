class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :basket]
  before_action :authenticate_customer!, only: [:checkout, :payment, :confirmation]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all.paginate(page: params[:page], :per_page => 30)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @payments = @order.payments.to_a
  end

  # GET /basket/1
  def basket
    @payments = @order.payments.to_a
  end

  # GET /orders/new
  def new
    @order = Order.new
    @order.order_items.build
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

  def checkout
    @order = Order.find(current_order.id)
    @order.customer = current_customer

    redirect_to catalog_products_path, flash: { alert: 'Your Cart is empty' } if @order.order_items.empty?

    if request.patch?
      @order.ip_address = request.ip
      if @order.proceed_to_confirm
        redirect_to checkout_payment_path
      end
    else
      # Add some example order data for the example. In a real application
      # this shouldn't be present.
    end
  end

  def payment
    @order = Order.find(current_order.id)
    if request.patch?
      redirect_to checkout_confirmation_path
    end
  end

  def confirmation
    unless current_order.confirming?
      redirect_to checkout_path
      return
    end

    #if request.patch?
      begin
        current_order.confirm!
        # This payment method should usually be called in a payment module or elsewhere but for the demo
        # we are adding a payment to the order straight away.
        current_order.payments.create(:amount => current_order.total, :reference => rand(10000) + 10000, :refundable => true)
        session[:order_id] = nil
        redirect_to root_path, :notice => "Order has been accepted!"
      rescue  => e
        flash[:alert] = "Payment was declined by the bank. #{e.message}"
        redirect_to checkout_path
      end
    #end
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
