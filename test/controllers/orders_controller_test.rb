require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @order = orders(:one)
  end


  test "should show order" do
    get :show, id: @order
    assert_response :success
  end


end
