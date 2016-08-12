require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @customer = customers(:one)
    @request.env["user_mailer.mapping"] = Devise.mappings[:customer]
    #get :new
  end

  test "should get index" do
    get :index, locale: I18n.default_locale
    assert_response :success
    assert_not_nil assigns(:customers)
  end

  test "should get new" do
    get :new, locale: I18n.default_locale
    assert_response :success
  end

  test "should create customer" do
    assert_difference('Customer.count') do
      post :create, customer: { email: 'tralala@test.com', password: 'tralala1*', password_confirmation: 'tralala1*', first_name: @customer.first_name, mobile: @customer.mobile, name: @customer.name }, locale: I18n.default_locale
    end

    assert_redirected_to customer_path(assigns(:customer))
  end

  test "should show customer" do
    get :show, id: @customer, locale: I18n.default_locale
    assert_response :success
  end

  test "should get edit customer" do
    sign_in(@customer, scope: :customer)
    get :edit, id: @customer, locale: I18n.default_locale
    assert_response :success
  end

  test "should update customer" do
    sign_in(@customer, scope: :customer)
    patch :update, id: @customer, customer: { email: @customer.email, first_name: @customer.first_name, mobile: @customer.mobile, name: @customer.name, picture: @customer.picture }, locale: I18n.default_locale
    assert_redirected_to customer_path(assigns(:customer))
  end

  test "should destroy customer without order" do
    assert_difference('Customer.count', -1) do
      delete :destroy, id: customers(:customer_without_orders), locale: I18n.default_locale
    end

    assert_redirected_to customers_path
  end


  test "should not destroy customer with order" do
    assert_difference('Customer.count', 0) do
      delete :destroy, id: customers(:one), locale: I18n.default_locale
    end

    assert_redirected_to catalog_products_path
  end

end
