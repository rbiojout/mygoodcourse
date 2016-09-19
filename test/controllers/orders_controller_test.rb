require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @order = orders(:one)
  end


  test "should show order" do
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
    get :show, id: @order
    assert_response :success
  end

  test "need signed customer" do
    get :show, id: @order
    assert_redirected_to new_customer_session_path
  end

  test "should not show order when wrong customer" do
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
    get :show, id: @order
    assert_response :success

    get :show, id: orders(:buyer_one_accepted)
    assert_redirected_to catalog_products_path
  end


end
