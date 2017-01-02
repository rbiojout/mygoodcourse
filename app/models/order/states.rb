class Order < ActiveRecord::Base
  STATUSES = %w(created confirming received accepted rejected).freeze

  # State Machine
  include AASM

  aasm column: 'status' do
    state :created, initial: true
    state :confirmed, :received, :accepted, :rejected

    event :confirm do
      before do
        logger.debug('Preparing to confirm')
      end
      transitions from: :created, to: :confirmed, after: :run_confirm
    end

    event :receive do
      transitions from: :confirmed, to: :received, after: :run_receive
    end

    event :accept do
      transitions from: :received, to: :accepted, guard: :confirming_ok?, after: :run_accept
    end

    event :reject do
      transitions from: :received, to: :rejected, after: :run_reject
    end

    event :reset do
      transitions from: [:rejected, :confirmed, :received], to: :received, after: :run_reset
    end
  end

  def confirming_ok?
    # don't consider confirmation if total amount is null
    if total.zero?
      true
    elsif stripe_customer_token && total > 0.0
      # not_charged_to_sellers = 0.0
      # ref_charges = ''
      # group by seller
      group_by_seller = order_items.group_by { |d| Product.find(d[:product_id])[:customer_id] }
      begin
        # we collect for each seller
        group_by_seller.each do |_key, value|
          # take the corresponding Stripe Account
          # stripe_account_seller = value.first.product.customer.stripe_account

          transfer_to_stripe(value)
          true
        end

      # payments.create(amount: total, method: 'Stripe', reference: charge.id, refundable: true, confirmed: false)
      # rescue ::Stripe::CardError
      rescue => e
        logger.debug("----------- error #{e}")

        logger.error e.message
        e.backtrace.each { |line| logger.error line }

        raise StandardError.new("Payment was declined by the payment processor #{e.message}.")
        false
      end
    end
  end

  def run_confirm
    order_items.each(&:confirm!)
  end

  def run_receive
    self.received_at = Time.now
    order_items.each(&:receive!)

    # Send an email to the customer
    # deliver_received_order_email
  end

  def run_accept
    self.accepted_at = Time.now

    # Send an email to the customer
    deliver_accepted_order_email
  end

  def run_reject
    self.rejected_at = Time.now

    # Send an email to the customer
    deliver_rejected_order_email
  end

  def run_reset
    order_items.each(&:reset!)
  end

  def deliver_accepted_order_email
    OrderMailer.accepted(self).deliver_now
  end

  def deliver_rejected_order_email
    OrderMailer.rejected(self).deliver_now
  end

  def deliver_received_order_email
    OrderMailer.received(self).deliver_now
  end

private

  def transfer_to_stripe(regrouped_orders_items)
    # we prepare the sum of all orders_item
    amout_total = 0.0
    application_fee_total = 0.0
    share_seller = 0.0
    regrouped_orders_items.each do |roi|
      amout_total += roi.unit_price
      application_fee_total += roi.application_fee
      share_seller += roi.unit_cost_price
    end

    # @TODO if the total amount is 0.0 we don't charge with Stripe

    # take the corresponding Stripe Account
    stripe_account_seller = regrouped_orders_items.first.product.customer.stripe_account
    if stripe_account_seller.nil? && amout_total > 0.0

      # notes += "StripeAccount null for some items."
      # we charge all to the platform
      # @TODO handle exception to continue treat other charges

      charge = ::Stripe::Charge.create({amount: (amout_total * BigDecimal(100)).round, currency: 'EUR', customer: stripe_customer_token, capture: true}, Rails.application.secrets.stripe_secret_key)
      # we log the reference in the lines or orders_items
      regrouped_orders_items.each do |roi|
        roi.method = 'Stripe'
        # we keep track of the needed CashOut
        roi.processing_reference = charge.id
        # add the fact that we have confirmation from Stripe
        begin
          roi.receive!
          if charge.paid?
            roi.accept!
          else
            roi.reject!
          end
        rescue => e
          logger.error e.message
          e.backtrace.each { |line| logger.error line }

          raise StandardError.new("Error during change state #{e.message}.")
        end
      end
      # we log at the order level
      if charge.paid
        self.amount_paid += amout_total
        save
        # @TODO add method stripe in the list of methods for payment
        # @TODO add a split of payments to the owner and to the platform
        # if the user_mailer is managed, send money else keep and schedule when possible
        payments.create(amount: amout_total, method: 'stripe', reference: charge.id, refundable: true, confirmed: true)
      end

    elsif amout_total > 0.0
      # we charge to the seller
      # @TODO if the OAuth is no more valid we must handle this and use the platform
      charge = ::Stripe::Charge.create({amount: (amout_total * BigDecimal(100)).round, currency: 'EUR', customer: stripe_customer_token, destination: stripe_account_seller.stripe_user_id, application_fee: (application_fee_total * BigDecimal(100)).round, capture: true}, Rails.application.secrets.stripe_secret_key)
      # we log the reference in the lines or orders_items
      regrouped_orders_items.each do |roi|
        roi.method = 'Stripe'
        roi.processing_reference = charge.id
        # add the fact that we have confirmation from Stripe
        roi.receive!
        if charge.paid
          roi.cash_out!
        else
          roi.reject!
        end
      end
      # we log at the order level
      if charge.paid
        self.amount_paid += amout_total
        save
        # @TODO add method stripe in the list of methods for payment
        # @TODO add a split of payments to the owner and to the platform
        # if the user_mailer is managed, send money else keep and schedule when possible
        begin
          payments.create(amount: amout_total, method: 'stripe', reference: charge.id, refundable: true, confirmed: true)
        rescue => e
          logger.debug("Problem saving payment. #{e.message}")
          raise StandardError.new("Problem saving payment. #{e.message}")
        end
      end
    end
  end
end
