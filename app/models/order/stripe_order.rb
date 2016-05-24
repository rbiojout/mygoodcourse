class Order < ActiveRecord::Base
  def accept_stripe_token(token)
    if token.start_with?('tok')
      customer = ::Stripe::Customer.create({ description: "Customer for order #{number}", card: token }, Rails.application.secrets.stripe_secret_key)
      self.stripe_customer_token = customer.id
      save
    elsif token.start_with?('cus') && properties[:stripe_customer_token] != token
      self.stripe_customer_token = token
      save
    elsif self.stripe_customer_token && self.stripe_customer_token.start_with?('cus')
      true
    else
      false
    end
  end

  private

  def stripe_customer
    @stripe_customer ||= ::Stripe::Customer.retrieve(self.stripe_customer_token, Rails.application.secrets.stripe_secret_key)
  end

  def stripe_card
    @stripe_card ||= stripe_customer.cards.last
  end
end