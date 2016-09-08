require 'test_helper'

class AbusesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @abuse = abuses(:comment_one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  test "should get new" do
    get :new, :comment_id => comments(:one).id
    assert_response :success

    assert_not_nil '#app_dialog #modal-dialog'
  end

  test "should not create abuse if not signed-in" do
    sign_out(customers(:one))
    assert_no_difference('Abuse.count') do
      post :create, abuse: { description: @abuse.description }, comment_id: comments(:one).id
    end

    assert_redirected_to new_customer_session_path
  end

  test "should create abuse for Comment" do
    assert_difference('Abuse.count') do
      post :create, abuse: { description: @abuse.description }, comment_id: comments(:one).id
    end

    # check customer
    assert_equal assigns(:abuse).customer, customers(:one)

    assert_redirected_to comment_path(id: comments(:one).id)
  end


  test "should create abuse for Comment via ajax" do
    sign_in(customers(:one), scope: :customer)
    assert_difference('Abuse.count') do
      xhr :post, :create, abuse: { description: @abuse.description }, comment_id: comments(:one).id
    end

    assert_response :success
    #assert_select_jquery :after, '#comment-form' do
    #  assert_select '.hidden-xs p', @comment.description
    #end

  end


  test "should create abuse for Product" do
    assert_difference('Abuse.count') do
      post :create, abuse: { description: @abuse.description }, product_id: products(:one).id
    end

    # check customer
    assert_equal assigns(:abuse).customer, customers(:one)

    # product use friendly_id for the id
    assert_redirected_to product_path(id: products(:one).friendly_id)
  end


  test "should create abuse for Product via ajax" do
    sign_in(customers(:one), scope: :customer)
    assert_difference('Abuse.count') do
      xhr :post, :create, abuse: { description: @abuse.description }, product_id: products(:one).id
    end

    assert_response :success
    #assert_select_jquery :after, '#comment-form' do
    #  assert_select '.hidden-xs p', @comment.description
    #end

  end


end
