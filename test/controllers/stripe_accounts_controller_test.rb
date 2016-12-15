require 'test_helper'

class StripeAccountsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @customer = customers(:one)
    @request.env['user_mailer.mapping'] = Devise.mappings[:customer]
    # get :new
  end

  test 'should test standalone' do
    sign_in(@customer, scope: :customer)
    get :standalone
    assert_redirected_to customer_path(@customer)
  end
end
