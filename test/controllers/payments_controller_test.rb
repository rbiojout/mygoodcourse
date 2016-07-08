require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @payment = payments(:one)
    # add a signed employee to perform the tests
    sign_in :employee, (employees(:one))
  end


  test "should not show payment" do
    get :show, id: @payment
    assert_redirected_to root_path
  end

  test "should show payment if signed" do
    sign_in :customer, customers(:one)
    get :show, id: @payment
    assert_response :success
  end
end
