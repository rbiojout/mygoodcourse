class OrdersController < ApplicationController
  before_action :set_order, only: [:show]
  before_action :authenticate_customer!, only: [:checkout, :payment, :confirmation, :myorders]

  helper_method :sort_column, :sort_direction


  # GET /myorders
  def myorders
    @orders = Order.accepted_for_customer(current_customer.id).order( sort_column + " " + sort_direction).paginate(page: params[:page], :per_page => PAGINATE_PAGES)
    @products = Product.find_ordered_by_customer(current_customer.id).paginate(page: params[:page], :per_page => PAGINATE_PAGES)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @payments = @order.payments.to_a
  end


  def accept
    @order.accept!(current_customer)
    redirect_to @order, flash: { notice: t('dialog.shop.notice_order_accepted') }
  rescue Errors::PaymentDeclined => e
    redirect_to @order, flash: { alert: e.message }
  end

  def reject
    @order.reject!(current_customer)
    redirect_to @order, flash: { notice: t('dialog.shop.notice_order_rejected')   }
  rescue Errors::PaymentDeclined => e
    redirect_to @order, flash: { alert: e.message }
  end

  def ship
    @order.ship!(params[:consignment_number], current_customer)
    redirect_to @order, flash: { notice: t('dialog.shop.notice_orders_shiped') }
  end

  # GET /checkout
  # PATCH /checkout
  def checkout
    current_order.customer = current_customer

    redirect_to catalog_products_path, flash: { alert: t('dialog.shop.alert_empty_cart') } if current_order.order_items.empty?

    # update the status
    current_order.ip_address = request.ip
    current_order.status = "confirming"
    # store in DB
    current_order.save
    @order = current_order
  end

  # GET /checkout/pay
  # PATCH /checkout/pay
  def payment
    @order = Order.find(current_order.id)
    if request.post?
      if @order.accept_stripe_token(params[:stripe_token])
        redirect_to checkout_confirmation_path
      else
        flash.now[:notice] = t('stripe.dialog.exchange_notice')
      end
    end
    #if request.patch?
    #  redirect_to checkout_confirmation_path
    #end
  end

  # GET /checkout/confirm
  # PATCH /checkout/confirm
  def confirmation
    unless current_order.confirming?
      redirect_to checkout_path
      return
    end

    # validate card infos
    #@TODO use validation of card (done only at js level so far)


    #if request.patch?
      begin
        current_order.accept_stripe_token(params[:stripeToken])
        current_order.confirm!
        # This payment method should usually be called in a payment module or elsewhere but for the demo
        # we are adding a payment to the order straight away.
        # charge = ::Stripe::Charge.create({ customer: current_order.stripe_customer_token, amount: (current_order.total * BigDecimal(100)).round, currency: 'EUR', capture: false }, Rails.application.secrets.stripe_secret_key)

        #current_order.payments.create(:amount => current_order.total, :reference => rand(10000) + 10000, :refundable => true)
        session[:order_id] = nil
        # save the amount paid
        current_order.amount_paid = current_order.total
        # save the state from the payment module as accepted
        current_order.accept!(current_customer)
        redirect_to root_path, :notice => t('dialog.shop.notice_pay_accepted')

      rescue  => e
        flash[:alert] = "#{I18n.translate('activerecord.attributes.order.reject_notice')} #{e.message}"
        logger.debug("Payment was declined by the bank. #{e.message}")
        # save the state from the payment module as rejected
        current_order.reject!(current_customer)
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
