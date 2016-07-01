class Order < ActiveRecord::Base
  extend ActiveModel::Callbacks

  # These additional callbacks allow for applications to hook into other
  # parts of the order lifecycle.
  define_model_callbacks :confirmation, :acceptance, :rejection

  # This method should be called by the base application when the user_mailer has completed their
  # first round of entering details. This will mark the order as "confirming" which means
  # the customer now just must confirm.
  #
  # @return [Boolean]
  def change_to_confirming
    self.status = 'confirming'
    true
  end

  # we try to charge to Stripe before to confirm
  # we group the orders by seller
  # then ask Stripe to validate
  # if the seller has not Stripe account we don't process and mark the status "received"
  # if the validation is OK, we mark the Order_items with the confirmation number from stripe and the status "accepted"
  # else we mark with the status "rejected"
  # @TODO handle the FREE products too
  before_confirmation do
    if self.stripe_customer_token && total > 0.0
      not_charged_to_sellers = 0.0
      ref_charges = ""
      # group by seller
      group_by_seller = self.order_items.group_by{ |d| Product.find(d[:product_id])[:customer_id]}
      begin
        # we collect for each seller
        group_by_seller.each do |key, value|
          # take the corresponding Stripe Account
          stripe_account_seller = value.first.product.customer.stripe_account

          transfer_to_stripe(value)
        end


        #payments.create(amount: total, method: 'Stripe', reference: charge.id, refundable: true, confirmed: false)
      #rescue ::Stripe::CardError
      rescue
        raise Errors::PaymentDeclined, 'Payment was declined by the payment processor.'
      end
    end
  end


  # This method should be executed by the application when the order should be completed
  # by the customer. It will raise exceptions if anything goes wrong or return true if
  # the order has been confirmed successfully
  #
  # @return [Boolean]
  def confirm!

    run_callbacks :confirmation do
      # If we have successfully charged the card (i.e. no exception) we can go ahead and mark this
      # order as 'received' which means it can be accepted by staff.
      self.status = 'received'
      self.received_at = Time.now
      save!

      order_items.each(&:confirm!)

      # Send an email to the customer
      deliver_received_order_email
    end

    # We're all good.
    true
  end

  # Mark order as accepted
  #
  # @param user [User] the user_mailer who carried out this action
  def accept!(user = nil)
    run_callbacks :acceptance do
      self.accepted_at = Time.now
      self.accepter = user if user
      self.status = 'accepted'
      save!
      order_items.each(&:accept!)
      deliver_accepted_order_email
    end
  end

  # Mark order as rejected
  #
  # @param user [Shoppe::User] the user_mailer who carried out the action
  def reject!(user = nil)
    run_callbacks :rejection do
      self.rejected_at = Time.now
      self.rejecter = user if user
      self.status = 'rejected'
      save!
      order_items.each(&:reject!)
      deliver_rejected_order_email
    end
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

    #@TODO if the total amount is 0.0 we don't charge with Stripe


    # take the corresponding Stripe Account
    stripe_account_seller = regrouped_orders_items.first.product.customer.stripe_account
    if (stripe_account_seller.nil? && amout_total > 0.0)
      #notes += "StripeAccount null for some items."
      #we charge all to the platform
      # @TODO handle exception to continue treat other charges

      charge = ::Stripe::Charge.create({ amount: (amout_total * BigDecimal(100)).round, currency: 'EUR', customer: self.stripe_customer_token, capture: true }, Rails.application.secrets.stripe_secret_key)
      # we log the reference in the lines or orders_items
      regrouped_orders_items.each do |roi|
        roi.method = "Stripe"
        # we keep track of the needed CashOut
        roi.status = charge.paid? ? "tocashout":"refused"
        roi.processing_reference = charge.id
      end
      # we log at the order level
      if charge.paid
        self.amount_paid += amout_total
        self.save
# @TODO add method stripe in the list of methods for payment
# @TODO add a split of payments to the owner and to the platform
# if the user_mailer is managed, send money else keep and schedule when possible
        payments.create(:amount => amout_total, :method => 'stripe', :reference => charge.id, :refundable => true, confirmed: true)

      else
        notes += "Some items where not accepted by the Bank."
      end


    elsif amout_total > 0.0
      # we charge to the seller
      # @TODO if the OAuth is no more valid we must handle this and use the platform
      charge = ::Stripe::Charge.create({ amount: (amout_total * BigDecimal(100)).round, currency: 'EUR', customer: self.stripe_customer_token, destination: stripe_account_seller.stripe_user_id, application_fee: (application_fee_total * BigDecimal(100)).round, capture: true }, Rails.application.secrets.stripe_secret_key)
      # we log the reference in the lines or orders_items
      regrouped_orders_items.each do |roi|
        roi.method = "Stripe"
        roi.status = charge.paid? ? "accepted":"refused"
        roi.processing_reference = charge.id
      end
      # we log at the order level
      if charge.paid
        self.amount_paid += amout_total
        self.save
# @TODO add method stripe in the list of methods for payment
# @TODO add a split of payments to the owner and to the platform
# if the user_mailer is managed, send money else keep and schedule when possible
        payments.create(:amount => amout_total, :method => 'stripe', :reference => charge.id, :refundable => true, confirmed: true)
      else
        notes += "Some items where not accepted by the Bank."
      end
    end
  end

end

