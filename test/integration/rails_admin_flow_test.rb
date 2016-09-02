require 'test_helper'

class RailsAdminFlowTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  test "login as admin" do
    login_as_admin
    get "/admin"
    assert_response :success

  end

  ###################################
  # test models
  ###################################

  test "customer admin functions" do
    login_as_admin

    get "/admin/customer"
    assert_response :success

    get "/admin/customer/new"
    assert_response :success

    customer = customers(:one)

    get "/admin/customer/#{customer.id}"
    assert_response :success

    get "/admin/customer/#{customer.id}/edit"
    assert_response :success

  end

  test "employee admin functions" do
    login_as_admin

    get "/admin/employee"
    assert_response :success

    get "/admin/employee/new"
    assert_response :success

    employee = employees(:one)

    get "/admin/employee/#{employee.id}"
    assert_response :success

    get "/admin/employee/#{employee.id}/edit"
    assert_response :success

  end

  test "country admin functions" do
    login_as_admin

    get "/admin/country"
    assert_response :success

    get "/admin/country/new"
    assert_response :success

    country = countries(:one)

    get "/admin/country/#{country.id}"
    assert_response :success

    get "/admin/country/#{country.id}/edit"
    assert_response :success
  end

  ####################################
  # test custom dashboards
  ####################################
  test "stats users dashboard" do
    get "/admin/stats_users"
    assert_response 302
  end

  private

  def login_as_admin


    Warden.test_mode!

    employee = employees(:one)
    login_as(employee, :scope => :employee)
  end
end