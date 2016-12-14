class OrdersController < ApplicationController
  before_action :set_order, only: [:show]
  before_action :authenticate_customer!, only: [:show, :checkout, :payment, :confirmation, :myorders]

  before_action :correct_user, only: :show

  helper_method :sort_column, :sort_direction


  # GET /myorders
  def myorders
    @orders = Order.for_customer(current_customer.id).unscope(:order).order( sort_column + " " + sort_direction)
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

    # we want to remove the items already paid by the customer
    # we can only do it at this stage because we need to have a customer signed
    already_ordered = false
    current_order.order_items.each do |item|
      if item.product.candownload(current_customer)
        item.destroy
        already_ordered = true
      end
    end
    if already_ordered
      flash[:notice] = I18n.translate('dialog.shop.notice_already_ordered')
      redirect_to checkout_path
      return
    end

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
    # @TODO use validation of card (done only at js level so far)


    #if request.patch?
      begin
        token = params[:stripeToken]
        db_stripe_customer = current_customer.stripe_customer
        # if we receive a token: it is coming from a fresh card
        if token.start_with?('tok')
          #create a customer if needed
          if db_stripe_customer.nil?
            stripe_customer = ::Stripe::Customer.create({ description: "Customer for order #{current_order.id}", card: token }, Rails.application.secrets.stripe_secret_key)
            db_stripe_customer = StripeCustomer.create(customer: current_customer, stripe_id: stripe_customer.id, currency: stripe_customer.currency, delinquent: stripe_customer.delinquent)
            card = stripe_customer.sources.retrieve(stripe_customer.default_source)
            db_stripe_customer.stripe_cards.create(stripe_id: card.id, name: card.name, brand: card.brand, exp_month: card.exp_month, exp_year: card.exp_year, last4: card.last4, country: card.country, default_source: true)
          else
            # we add the card else and set as the prefered card
            stripe_customer = Stripe::Customer.retrieve(db_stripe_customer.stripe_id)

            card = stripe_customer.sources.create({:source => token})
            db_stripe_customer.stripe_cards.create(stripe_id: card.id, name: card.name, brand: card.brand, exp_month: card.exp_month, exp_year: card.exp_year, last4: card.last4, country: card.country, default_source: true)

            # set as the prefered
            stripe_customer.default_source = card.id
            stripe_customer.save
            # unset all other cards to unprefered
            db_stripe_customer.stripe_cards.each do |db_card|
              if db_card.stripe_id != card.id
                db_card.default_source = false
                db_card.save
              end
            end
          end
          token = stripe_customer.id

          #if we receive a customer: we use the default card
        elsif token.start_with?('cus')
          #we keep the token
          # we need to make sure the customer is the same as db
          db_stripe_customer = StripeCustomer.find_by_stripe_id(token)

          if db_stripe_customer.customer.id != current-customer.id
            flash[:alert] = "#{I18n.translate('dialog.shop.alert_rejected_order')} #{e.message}"
            logger.debug("Wrong customer without rights")
            current_order.reset! if current_order.may_reset?
            current_order.reject!
            redirect_to checkout_path
            return
          end
        elsif token.start_with?('card')
          #we need to get the customer
          db_stripe_card = StripeCard.find_by_stripe_id(token)
          db_stripe_customer = db_stripe_card.stripe_customer
          token = db_stripe_customer.stripe_id
          # make as the default card


          if db_stripe_customer.customer.id != current_customer.id
            flash[:alert] = "#{I18n.translate('dialog.shop.alert_rejected_order')} #{e.message}"
            logger.debug("Wrong customer without rights")
            current_order.reset! if current_order.may_reset?
            current_order.reject!
            redirect_to checkout_path
            return
          end

          # we add the card else and set as the prefered card
          stripe_customer = Stripe::Customer.retrieve(db_stripe_customer.stripe_id)

          # set as the prefered
          stripe_customer.default_source = db_stripe_card.stripe_id
          stripe_customer.save
          # unset all other cards to unprefered
          db_stripe_customer.stripe_cards.each do |db_card|
            if db_card.stripe_id != db_stripe_card.stripe_id
              db_card.default_source = false
              db_card.save
            end
          end

        end

        # if we receive a customer: it is coming from a customer already created with a store card
        current_order.accept_stripe_token(token)
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

    def correct_user
      redirect_to catalog_products_path, alert: t('dialog.restricted') unless @order.nil? || @order.customer_id == current_customer.id
    end

    # Used for sorting the list
    def sort_column
      Order.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
