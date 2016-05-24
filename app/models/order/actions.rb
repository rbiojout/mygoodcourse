class Order < ActiveRecord::Base
  extend ActiveModel::Callbacks

  # These additional callbacks allow for applications to hook into other
  # parts of the order lifecycle.
  define_model_callbacks :confirmation, :acceptance, :rejection

  # This method should be called by the base application when the user has completed their
  # first round of entering details. This will mark the order as "confirming" which means
  # the customer now just must confirm.
  #
  # @param params [Hash] a hash of order attributes
  # @return [Boolean]
  def change_to_confirming
    self.status = 'confirming'
    true
  end

  # we try to charge to Stripe before to confirm
  before_confirmation do
    if self.stripe_customer_token && total > 0.0
      not_charged_to_sellers = 0.0
      ref_charges = ""
      begin
        self.order_items.each do |order_item|
          product_price = order_item.unit_price
          application_fee = order_item.application_fee
          share_seller = order_item.unit_cost_price
          stripe_account_seller = order_item.product.customer.stripe_account
          if (stripe_account_seller.nil?)
            not_charged_to_sellers += product_price
          else
            charge = ::Stripe::Charge.create({ customer: self.stripe_customer_token, amount: (product_price * BigDecimal(100)).round, currency: 'EUR', capture: true, destination: stripe_account_seller.stripe_user_id, application_fee: (application_fee * BigDecimal(100)).round }, Rails.application.secrets.stripe_secret_key)
            ref_charges += charge.id + "-"
          end
        end

        if not_charged_to_sellers > 0.0
          charge = ::Stripe::Charge.create({ customer: self.stripe_customer_token, amount: (not_charged_to_sellers * BigDecimal(100)).round, currency: 'EUR', capture: true }, Rails.application.secrets.stripe_secret_key)
          ref_charges += charge.id
        end
        # @TODO add method stripe in the list of methods for payment
        # @TODO add a split of payments to the owner and to the platform
        # if the user is managed, send money else keep and schedule when possible
        payments.create(:amount => total, :reference => ref_charges, :refundable => true, confirmed: true)



        #payments.create(amount: total, method: 'Stripe', reference: charge.id, refundable: true, confirmed: false)
      rescue ::Stripe::CardError
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
  # @param user [User] the user who carried out this action
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
  # @param user [Shoppe::User] the user who carried out the action
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
end

