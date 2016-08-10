require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @payment = payments(:one)
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope:  :employee)
  end


  test "should not show payment" do
    get :show, id: @payment
    assert_redirected_to catalog_products_path
  end

  test "should show payment if signed" do
    sign_in(customers(:one), scope:  :customer)
    get :show, id: @payment
    assert_response :success
  end
end
