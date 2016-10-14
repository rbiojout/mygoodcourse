require 'test_helper'

# we use accounts from Skipe
# fmc.buyer1@gmail.com, fmc.buyer2@gmail.com, fmc.seller1@gmail.com, fmc.seller2@gmail.com
# IBAN FR1420041010050500013M02606

class CheckoutFlowTest < ActionDispatch::IntegrationTest

  # make a wrong login
  test "wrong login" do
    # login via https
    https!(false)
    get new_customer_session_path
    assert_equal 200, status
    hash = Devise::Encryptor.digest(Customer, "BadPassword")

    # make a bad login
    post new_customer_session_path, 'customer[email]' => customers(:buyer_one).email, 'customer[password]' => "BadPassword"

    assert_equal new_customer_session_path, path
    assert_equal I18n.t('customers.failure.invalid'), flash[:alert]
    assert_select '.alert-danger > p', I18n.t('customers.failure.invalid')

  end

  # fill cart after login
  test "fill cart" do
    # login via https
    https!(false)
    get new_customer_session_path
    assert_equal 200, status
    hash = Devise::Encryptor.digest(Customer, "Helloworld1*")


    # make a good login
    post new_customer_session_path, 'customer[email]' => customers(:buyer_one).email, 'customer[password]' => "Helloworld1*"
    follow_redirect!

    assert_equal 200, status
    assert_equal catalog_products_path, path
    assert_equal I18n.t('customers.sessions.signed_in'), flash[:notice]
    assert_select '.alert-success > p', I18n.t('customers.sessions.signed_in')

    get '/products', :id => products(:free_from_seller_one).id
    assert_response :success


    post buy_product_path(:product_id => products(:free_from_seller_one).id)
    post buy_product_path(:product_id => products(:one_from_seller_one).id)
    post buy_product_path(:product_id => products(:two_from_seller_one).id)
    post buy_product_path(:product_id => products(:one_from_seller_two).id)
    post buy_product_path(:product_id => products(:one_from_seller_no_stripe).id)

    get checkout_path

    Stripe.api_key = Rails.application.secrets.stripe_secret_key
    # test if the number is OK
    assert_raises do
      token = Stripe::Token.create(
          :card => {
              :number => "42424242",
              :exp_month => 5,
              :exp_year => 2017,
              :cvc => "314"
          },
      )
    end
    # create a token
    token = Stripe::Token.create(
        :card => {
            :number => "4242424242424242",
            :exp_month => 5,
            :exp_year => 2027,
            :cvc => "314"
        },
    )
    assert_equal "token", token[:object]
    assert_equal false, token[:livemode]
    assert_equal "card", token[:type]
    assert_not_equal nil, token[:card][:id]

    get checkout_confirmation_path, :stripeToken => token[:id]

    https!(false)
    #get "/articles/all"
    #assert_response :success
    #assert assigns(:articles)
  end

  test "accept payment" do
    prepare_cart


    # we have an order
    @current_order = assigns(:current_order)

    Stripe.api_key = Rails.application.secrets.stripe_secret_key
    # create a token
    token = Stripe::Token.create(
        :card => {
            :number => "4242424242424242",
            :exp_month => 5,
            :exp_year => 2027,
            :cvc => "314"
        },
    )
    @current_order = assigns(:current_order)

    get checkout_confirmation_path, :stripeToken => token[:id]

    assert_equal I18n.t('dialog.shop.notice_pay_accepted'), flash[:notice]

    @current_order = assigns(:current_order)
    assert @current_order.accepted?
    assert_not @current_order.may_reset?
  end


  test "bypass pending balance" do
    prepare_cart

    # we have an order
    @current_order = assigns(:current_order)

    Stripe.api_key = Rails.application.secrets.stripe_secret_key
    # create a token
    token = Stripe::Token.create(
        :card => {
            :number => "4000000000000077",
            :exp_month => 5,
            :exp_year => 2027,
            :cvc => "314"
        },
    )

    get checkout_confirmation_path, :stripeToken => token[:id]

    assert_equal I18n.t('dialog.shop.notice_pay_accepted'), flash[:notice]

    @current_order = assigns(:current_order)
    assert @current_order.accepted?
    assert_not @current_order.may_reset?


  end


  test "charge failed even if customer ok" do
    prepare_cart

    # we have an order
    @current_order = assigns(:current_order)

    Stripe.api_key = Rails.application.secrets.stripe_secret_key
    # test if the number is OK
    # create a token
    token = Stripe::Token.create(
        :card => {
            :number => "4000000000000341",
            :exp_month => 5,
            :exp_year => 2027,
            :cvc => "314"
        },
    )

    get checkout_confirmation_path, :stripeToken => token[:id]
    assert_match I18n.t('dialog.shop.alert_rejected_order'), flash[:alert]

    #@TODO look to uninitialized constant Order::Errors
    @current_order = assigns(:current_order)
    assert @current_order.rejected?
    assert @current_order.may_reset?

  end

  test "checkout" do
    prepare_cart

    assert_select "#stripe-form"

    assert_select "#stripe-form input[value=?]", I18n.t('actions.pay')

    @current_order = assigns(:current_order)

    assert_not_nil @current_order
    assert_not_nil @current_customer
    assert_not_nil @current_order.customer
    assert @current_order.received?

  end

  test "customer can not order its own products" do

  end


  # create a fresh checkout
  def prepare_cart
    get new_customer_session_path

    # make a good login
    post new_customer_session_path, 'customer[email]' => customers(:buyer_one).email, 'customer[password]' => "Helloworld1*"
    follow_redirect!

    assert_equal 200, status
    assert_equal catalog_products_path, path
    assert_equal I18n.t('customers.sessions.signed_in'), flash[:notice]
    assert_select '.alert-success > p', I18n.t('customers.sessions.signed_in')

    @current_customer = assigns(:current_customer)

    assert_not_nil @current_customer


    post buy_product_path(:product_id => products(:free_from_seller_one).id)
    post buy_product_path(:product_id => products(:one_from_seller_one).id)
    post buy_product_path(:product_id => products(:two_from_seller_one).id)
    post buy_product_path(:product_id => products(:one_from_seller_two).id)
    post buy_product_path(:product_id => products(:one_from_seller_no_stripe).id)

    # we have an order
    @current_order = assigns(:current_order)
    assert @current_order.order_items.count, 5

    get checkout_path

    # some products have already been ordered
    assert_equal I18n.t('dialog.shop.notice_already_ordered'), flash[:notice]

    assert @current_order.may_confirm?

    assert @current_order.order_items.count, 3
    # submit with less products
    get checkout_path


  end



end