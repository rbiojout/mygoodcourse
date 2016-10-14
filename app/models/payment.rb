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
  belongs_to :order

  def stripe_charge
    @stripe_charge ||= ::Stripe::Charge.retrieve(reference, Rails.application.secrets.stripe_secret_key)
  end

  def transaction_url
    "https://manage.stripe.com/#{Rails.env.production? ? '/' : 'test/'}payments/#{reference}"
  end

end
