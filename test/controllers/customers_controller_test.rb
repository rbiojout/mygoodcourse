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


  test "should show customer" do
    get :show, id: @customer, locale: I18n.default_locale
    assert_response :success
  end

  test "should impression show customer" do
    customer = customers(:one)
    assert_difference ('customer.counter_cache') do
      # @TODO why needed double?
      get :show, locale: I18n.default_locale, id: customer
      get :show, locale: I18n.default_locale, id: customer
      customer = assigns(:customer)
    end
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

  test "should have circle" do
    # test the routing with customer one
    get :circle, id: @customer.id, locale: I18n.default_locale
    assert_response :success
    assert_not_nil assigns(:followers)
    assert_not_nil assigns(:followeds)
    assert_select 'div#followers'
    assert_select 'div#followeds'

    # we use after a signed user
    sign_in(@customer, scope: :customer)

    get :circle, id: customers(:two).id, locale: I18n.default_locale
    assert_response :success
    assert_not_nil assigns(:followers)
    assert_not_nil assigns(:followeds)
    assert_select 'div#followers'
    assert_select 'div#followeds'
  end

  test "should have wishlist" do
    get :wishlist, id: @customer.id, locale: I18n.default_locale
    assert_response :success
    assert_not_nil assigns(:products)

    # we use after a signed user
    sign_in(@customer, scope: :customer)

    get :wishlist, id: customers(:two).id, locale: I18n.default_locale

    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should have comments list" do
    get :comments_list, id: @customer.id, locale: I18n.default_locale
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should have dashboard" do
    # protected if not signed
    get :dashboard, id: @customer.id, locale: I18n.default_locale
    assert_response 302

    # access if signed in customer
    sign_in(@customer, scope: :customer)
    get :dashboard, id: @customer.id, locale: I18n.default_locale
    assert_response :success
  end

end
