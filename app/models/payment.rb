class Payment < ActiveRecord::Base
  belongs_to :order

  def stripe_charge
    @stripe_charge ||= ::Stripe::Charge.retrieve(reference, Rails.application.secrets.stripe_secret_key)
  end

  def transaction_url
    "https://manage.stripe.com/#{Rails.env.production? ? '/' : 'test/'}payments/#{reference}"
  end

end
