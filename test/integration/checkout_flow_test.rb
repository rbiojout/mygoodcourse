require 'test_helper'

class CheckoutFlowTest < ActionDispatch::IntegrationTest

  test "fill cart" do
    # login via https
    https!(false)
    get new_customer_session_path
    assert_equal 200, status
    hash = Devise::Encryptor.digest(Customer, "Helloworld1*")

    post new_customer_session_path, 'customer[email]' => customers(:buyer_one).email, 'customer[password]' => "Helloworld1*"

    follow_redirect!
    assert_equal 200, status
    assert_equal root_path, path
    assert_equal 'Signed in successfully.', flash[:notice]

    get '/products', :id => products(:free_from_seller_one).id
    assert_response :success


    post buy_product_path(:product_id => products(:free_from_seller_one).id)
    post buy_product_path(:product_id => products(:one_from_seller_one).id)
    post buy_product_path(:product_id => products(:two_from_seller_one).id)
    post buy_product_path(:product_id => products(:one_from_seller_two).id)

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
            :exp_year => 2017,
            :cvc => "314"
        },
    )
    assert_equal "token", token[:object]
    assert_equal false, token[:livemode]
    assert_equal "card", token[:type]
    assert_not_equal nil, token[:card][:id]
    puts token

    get checkout_confirmation_path, :stripeToken => token[:id]

    https!(false)
    #get "/articles/all"
    #assert_response :success
    #assert assigns(:articles)
  end
end