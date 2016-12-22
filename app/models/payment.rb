# == Schema Information
#
# Table name: payments
#
#  id                :integer          not null, primary key
#  order_id          :integer
#  amount            :decimal(, )
#  reference         :string
#  confirmed         :boolean
#  refundable        :boolean
#  amount_refunded   :decimal(, )
#  parent_payment_id :integer
#  exported          :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  method            :string
#
# Indexes
#
#  index_payments_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_6af949464b  (order_id => orders.id)
#

class Payment < ActiveRecord::Base
  # Additional callbacks
  extend ActiveModel::Callbacks
  define_model_callbacks :refund

  belongs_to :order

  def stripe_charge
    @stripe_charge ||= ::Stripe::Charge.retrieve(reference, Rails.application.secrets.stripe_secret_key)
  end

  def transaction_url
    "https://manage.stripe.com/#{Rails.env.production? ? '/' : 'test/'}payments/#{reference}"
  end

  # Is this payment a refund?
  #
  # @return [Boolean]
  def refund?
    amount < BigDecimal(0)
  end

  # Has this payment had any refunds taken from it?
  #
  # @return [Boolean]
  def refunded?
    amount_refunded > BigDecimal(0)
  end

  # How much of the payment can be refunded
  #
  # @return [BigDecimal]
  def refundable_amount
    refundable? ? (amount - amount_refunded) : BigDecimal(0)
  end

  # Process a refund from this payment.
  #
  # @param amount [String] the amount which should be refunded
  # @return [Boolean]
  def refund!(amount)
    run_callbacks :refund do
      amount = BigDecimal(amount)
      if refundable_amount >= amount
        transaction do
          self.class.create(order_id: order_id, amount: 0 - amount, method: method, reference: reference)
          update_attribute(:amount_refunded, amount_refunded + amount)
          # @TODO parent order
          true
        end
      else
        fail Errors::StandardError, message: I18n.t('.refund_failed', refundable_amount: refundable_amount)
      end
    end
  end
end
