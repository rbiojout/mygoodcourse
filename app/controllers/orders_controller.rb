class OrdersController < ApplicationController
  before_action :set_order, only: [:show]
  before_action :authenticate_customer!, only: [:checkout, :payment, :confirmation, :myorders]

  helper_method :sort_column, :sort_direction


  # GET /myorders
  def myorders
    @orders = Order.accepted_for_customer(current_customer.id).order( sort_column + " " + sort_direction)
    @products = Product.find_bought_by_customer(current_customer.id)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @payments = @order.payments.to_a
  end


  # GET /checkout
  # PATCH /checkout
  # current_customer is needed to proceed
  # state is moved from created to confirmed
  # then state moved from confirmed to received
  def checkout
    current_order.customer = current_customer

    if current_order.order_items.empty?
      redirect_to catalog_products_path, flash: { alert: t('dialog.shop.alert_empty_cart') }
      return
    end
    # update the status
    current_order.ip_address = request.ip
    # change the state and save
    current_order.confirm! if current_order.may_confirm?

    current_order.receive! if current_order.may_receive?

    # store in session
    @order = current_order

    # if all orders are free skip payment
    if current_order.total ==0
      session[:order_id] = nil
      # save the amount paid

      current_order.amount_paid = current_order.total
      current_order.accept! if current_order.may_accept?
      redirect_to catalog_products_path, :notice => t('dialog.shop.notice_pay_accepted')
    end
  end

  # GET /checkout/confirm
  # PATCH /checkout/confirm
  def confirmation
    # we reset the status if we have a new submission
    if current_order.created?
      redirect_to checkout_path
      return
    end

    current_order.reset! if current_order.may_reset?

    # validate card infos
    #@TODO use validation of card (done only at js level so far)


    #if request.patch?
      begin
        current_order.accept_stripe_token(params[:stripeToken])
        # This payment method should usually be called in a payment module or elsewhere but for the demo
        # we are adding a payment to the order straight away.
        # charge = ::Stripe::Charge.create({ customer: current_order.stripe_customer_token, amount: (current_order.total * BigDecimal(100)).round, currency: 'EUR', capture: false }, Rails.application.secrets.stripe_secret_key)

        #current_order.payments.create(:amount => current_order.total, :reference => rand(10000) + 10000, :refundable => true)
        session[:order_id] = nil
        # save the state from the payment module as accepted
        current_order.accept!
        redirect_to catalog_products_path, :notice => t('dialog.shop.notice_pay_accepted')

      rescue  => e
        flash[:alert] = "#{I18n.translate('dialog.shop.alert_rejected_order')} #{e.message}"
        logger.debug("Payment was declined by the bank. #{e.message}")
        # save the state from the payment module as rejected
        current_order.reset! if current_order.may_reset?
        current_order.reject!
        redirect_to checkout_path
      end
    #end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:customer_id, :notes, order_item_attributes: [:id, :product_id, :price, :tax_rate, :tax_amount, :_destroy])
    end

    # Used for sorting the list
    def sort_column
      Order.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
