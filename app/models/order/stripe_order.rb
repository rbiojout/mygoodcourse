class Order < ActiveRecord::Base
  def accept_stripe_token(token)
    if token.start_with?('tok')
      stripe_customer = ::Stripe::Customer.create({description: "Customer for order #{number}", card: token}, Rails.application.secrets.stripe_secret_key)
      self.stripe_customer_token = stripe_customer.id
      save
    elsif token.start_with?('cus')
      self.stripe_customer_token = token
      save
    elsif stripe_customer_token && stripe_customer_token.start_with?('cus')
      true
    else
      false
    end
  end

private

  def stripe_customer
    @stripe_customer ||= ::Stripe::Customer.retrieve(stripe_customer_token, Rails.application.secrets.stripe_secret_key)
  end

  def stripe_card
    @stripe_card ||= stripe_customer.sources.retrieve(stripe_customer.default_source)
  end
end
