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

  test "should get new" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    get :new
    assert_response :success
  end

  test "should create country" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    assert_difference('Country.count') do
      post :create, country: { code2: @country.code2, code3: @country.code3, continent: @country.continent, currency: @country.currency, eu_member: @country.eu_member, name: @country.name, tld: @country.tld }
    end

    assert_redirected_to country_path(assigns(:country))
  end

  test "should show country" do
    get :show, id: @country
    assert_response :success
  end

  test "should get edit" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    get :edit, id: @country
    assert_response :success
  end

  test "should protect edit" do
    sign_out(employees(:one))
    get :edit, id: @country
    assert_redirected_to new_employee_session_path
  end


  test "should update country" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    patch :update, id: @country, country: { code2: @country.code2, code3: @country.code3, continent: @country.continent, currency: @country.currency, eu_member: @country.eu_member, name: @country.name, tld: @country.tld }
    assert_redirected_to country_path(assigns(:country))
  end

  test "should destroy country" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    @country = countries(:not_linked)
    assert_difference('Country.count', -1) do
      delete :destroy, id: @country
    end

    assert_redirected_to countries_path
  end

  test "should not destroy linked country" do
    # add a signed employee to perform the tests
    sign_in(employees(:one), scope: :employee)
    assert_raise ActiveRecord::InvalidForeignKey do
      delete :destroy, id: @country
    end
  end
end
