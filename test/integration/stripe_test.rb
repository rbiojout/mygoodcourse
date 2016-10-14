require 'test_helper'

# we use accounts from Skipe
# fmc.buyer1@gmail.com, fmc.buyer2@gmail.com, fmc.seller1@gmail.com, fmc.seller2@gmail.com
# IBAN FR1420041010050500013M02606

class StripeTest < ActionDispatch::IntegrationTest
  test "store card" do
    # retreive a customer
    current_customer = customers(:one)
    # current_customer = Customer.first
    # prepare an order
    current_order = Order.new
    current_order.customer = current_customer
    current_order.save
    # free_from_seller_one = Product.first
    # one_from_seller_one = Product.last
    free_from_seller_one = products(:free_from_seller_one)
    one_from_seller_one = products(:one_from_seller_one)

    order_item =
    current_order.order_items.add_item(free_from_seller_one)
    current_order.order_items.add_item(one_from_seller_one)
    current_order.confirm!

    # prepare the checkout
    # get a token from Stripe
    Stripe.api_key = Rails.application.secrets.stripe_secret_key
    # create a token
    stripeToken = Stripe::Token.create(
        :card => {
            :number => "4242424242424242",
            :exp_month => 5,
            :exp_year => 2027,
            :cvc => "314"
        },
    )


    # transform as customer
    number = current_order.id
    stripe_customer = ::Stripe::Customer.create({ description: "Customer for order #{number}", card: stripeToken }, Rails.application.secrets.stripe_secret_key)

    # store stripe_customer
    db_stripe_customer = StripeCustomer.create(customer: current_customer, stripe_id: stripe_customer.id, currency: stripe_customer.currency, delinquent: stripe_customer.delinquent)

    # check if creation ok in db
    assert stripe_customer.id, db_stripe_customer.stripe_id

    # retrieve default card
    card = stripe_customer.sources.retrieve(stripe_customer.default_source)

    # store the card
    # store in DB
    db_stripe_customer.stripe_cards.create(stripe_id: card.id, name: card.name, brand: card.brand, exp_month: card.exp_month, exp_year: card.exp_year, last4: card.last4, country: card.country, default_source: true)


    assert current_order.confirmed?
    # handle the process from Stripe
    current_order.reset! if current_order.may_reset?
    assert current_order.received?

    current_order.accept_stripe_token(db_stripe_customer.stripe_id)

    # test the acceptance
    current_order.accept!
    # check if accepted
    assert current_order.accepted?


    # check if we have good token from db
    assert stripe_customer.id, current_order.stripe_customer_token






    # then retrieve card
    #charge = ::Stripe::Charge.create({ amount: (current_order.total * BigDecimal(100)).round, currency: 'EUR', customer: current_customer.stripe_customer.stripe_id, capture: true }, Rails.application.secrets.stripe_secret_key)



    # charge the customer

    # save the state from the payment module as accepted
    #current_order.accept!

  end
end
