require 'test_helper'

class StripeAccountsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @customer = customers(:one)
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    #get :new
  end

  test "should test standalone" do
    sign_in :customer, @customer
    get :standalone
    assert_response :success
    assert_not_nil assigns(:customers)
  end



end
