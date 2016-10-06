require 'test_helper'

class CountriesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @country = countries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:countries)
  end

  test "should show country" do
    get :show, id: @country
    assert_response :success
  end

end
