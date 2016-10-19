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
    login_as_admin

    get "/admin/stats_users"
    assert_response :success
  end

  ####################################
  # test machine engine
  ####################################
  test "has admin state abuse" do
    login_as_admin

    get "/admin/abuse"
    assert_response :success

    abuse = abuses(:review_one)
    get "/admin/abuse/#{abuse.id}/receive_abuse"
    assert assigns(:object).received?

    get "/admin/abuse/#{abuse.id}/accept_abuse"
    assert assigns(:object).accepted?

    get "/admin/abuse/#{abuse.id}/cancel_abuse"
    assert assigns(:object).created?

    get "/admin/abuse/#{abuse.id}/receive_abuse"
    assert assigns(:object).received?

    get "/admin/abuse/#{abuse.id}/reject_abuse"
    assert assigns(:object).rejected?

  end

  test "has admin stat dashboard" do
    login_as_admin

    get "/admin/stats_users"

    assert_select "#CreatedCustomersChart"

    assert_select "#SignInCustomerChart"

    assert_select "#CreatedReviewsChart"
  end

  private

  def login_as_admin


    Warden.test_mode!

    employee = employees(:one)
    login_as(employee, :scope => :employee)
  end
end