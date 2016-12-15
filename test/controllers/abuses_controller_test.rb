require 'test_helper'

class AbusesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @abuse = abuses(:review_one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  test 'should get new' do
    get :new, review_id: reviews(:one).id
    assert_response :success

    assert_not_nil '#app_dialog #modal-dialog'
  end

  test 'should not create abuse if not signed-in' do
    sign_out(customers(:one))
    assert_no_difference('Abuse.count') do
      post :create, abuse: {description: @abuse.description}, review_id: reviews(:one).id
    end

    assert_redirected_to new_customer_session_path
  end

  test 'should create abuse for review' do
    assert_difference('Abuse.count') do
      post :create, abuse: {description: @abuse.description}, review_id: reviews(:one).id
    end

    # check customer
    assert_equal assigns(:abuse).customer, customers(:one)

    assert_redirected_to review_path(id: reviews(:one).id)
  end

  test 'should create abuse for review via ajax' do
    sign_in(customers(:one), scope: :customer)
    assert_difference('Abuse.count') do
      xhr :post, :create, abuse: {description: @abuse.description}, review_id: reviews(:one).id
    end

    assert_response :success

    assert_select_jquery :html, '#alert_notice_holder' do
      assert_select '.alert'
      assert_select '.alert p', I18n.translate('views.flash_create_message')
    end
  end

  test 'should create abuse for Product' do
    assert_difference('Abuse.count') do
      post :create, abuse: {description: @abuse.description}, product_id: products(:one).id
    end

    # check customer
    assert_equal assigns(:abuse).customer, customers(:one)

    # product use friendly_id for the id
    assert_redirected_to product_path(id: products(:one).friendly_id)
  end

  test 'should create abuse for Product via ajax' do
    sign_in(customers(:one), scope: :customer)
    assert_difference('Abuse.count') do
      xhr :post, :create, abuse: {description: @abuse.description}, product_id: products(:one).id
    end

    assert_response :success
    assert_select_jquery :html, '#alert_notice_holder' do
      assert_select '.alert'
      assert_select '.alert p', I18n.translate('views.flash_create_message')
    end
  end
end
