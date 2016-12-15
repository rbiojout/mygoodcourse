require 'test_helper'

class RailsAdminFlowTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  test 'login as admin' do
    login_as_admin
    get '/admin'
    assert_response :success
  end

  ###################################
  # test models
  ###################################

  test 'customer admin functions' do
    login_as_admin

    get '/admin/customer'
    assert_response :success

    get '/admin/customer/new'
    assert_response :success

    customer = customers(:one)

    get "/admin/customer/#{customer.id}"
    assert_response :success

    get "/admin/customer/#{customer.id}/edit"
    assert_response :success
  end

  test 'employee admin functions' do
    login_as_admin

    get '/admin/employee'
    assert_response :success

    get '/admin/employee/new'
    assert_response :success

    employee = employees(:one)

    get "/admin/employee/#{employee.id}"
    assert_response :success

    get "/admin/employee/#{employee.id}/edit"
    assert_response :success
  end

  test 'country admin functions' do
    login_as_admin

    get '/admin/country'
    assert_response :success

    get '/admin/country/new'
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
  test 'stats users dashboard' do
    login_as_admin

    get '/admin/stats_users'
    assert_response :success
  end

  ####################################
  # test machine engine
  ####################################
  test 'has admin state abuse' do
    login_as_admin

    get '/admin/abuse'
    assert_response :success

    abuse = abuses(:review_one)
    get "/admin/abuse/#{abuse.id}/receive_state"
    assert assigns(:object).received?

    get "/admin/abuse/#{abuse.id}/accept_state"
    assert assigns(:object).accepted?

    get "/admin/abuse/#{abuse.id}/cancel_state"
    assert assigns(:object).received?

    get "/admin/abuse/#{abuse.id}/reject_state"
    assert assigns(:object).rejected?
  end

  test 'has admin state post' do
    post = posts(:one)

    # prepare the file
    # we need to prepare in order to have the file present during the validation of the model
    post.visual = fixture_file_upload(Rails.root.join('test/fixtures/files/default_visual.png'), 'image/png')
    post.save

    login_as_admin

    get '/admin/post'
    assert_response :success

    assert post.may_receive?
    assert_select 'a[href=?]', root_url + "post/#{post.id}/receive_state"
    get "/admin/post/#{post.id}/receive_state"
    follow_redirect!
    assert assigns(:object).received?

    assert assigns(:object).may_accept?
    assert_select 'a[href=?]', root_url + "post/#{post.id}/accept_state"
    get "/admin/post/#{post.id}/accept_state"
    follow_redirect!
    assert assigns(:object).accepted?

    assert assigns(:object).may_cancel?
    assert_select 'a[href=?]', root_url + "post/#{post.id}/cancel_state"
    get "/admin/post/#{post.id}/cancel_state"
    follow_redirect!
    assert assigns(:object).received?

    assert assigns(:object).may_reject?
    assert_select 'a[href=?]', root_url + "post/#{post.id}/reject_state"
    get "/admin/post/#{post.id}/reject_state"
    puts '' + assigns(:object).to_s
    post = Post.find(post.id)
    puts post.status
    assert assigns(:object).rejected?
  end

  test 'has admin stat dashboard' do
    login_as_admin

    get '/admin/stats_users'

    assert_select '#CreatedCustomersChart'

    assert_select '#SignInCustomerChart'

    assert_select '#CreatedReviewsChart'
  end

private

  def login_as_admin
    Warden.test_mode!

    employee = employees(:one)
    login_as(employee, scope: :employee)
  end
end
