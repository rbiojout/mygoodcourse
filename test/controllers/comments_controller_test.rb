require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @comment = comments(:one)
    # add a signed customer to perform the tests
    sign_in :customer, (customers(:one))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post :create, comment: { description: @comment.description, product_id: @comment.product_id, score: @comment.score, title: @comment.title }
    end

    assert_redirected_to comment_path(assigns(:comment))
  end

  test "should create comment via ajax" do
    sign_in :customer, (customers(:one))
    assert_difference('Comment.count') do
      xhr :post, :create, comment: { description: @comment.description, product_id: @comment.product_id, score: @comment.score, title: @comment.title }
    end

    assert_response :success
    assert_select_jquery :after, '#comment-form' do
      #assert_select '.media-object img', @comment.customer.picture
      assert_select '.hidden-xs p', @comment.description
    end

  end

  test "need login to create comment" do
    sign_out :customer
    assert_no_difference('Comment.count') do
      post :create, comment: { description: @comment.description, product_id: @comment.product_id, score: @comment.score, title: @comment.title }
    end

    assert_redirected_to new_customer_session_path
  end

  test "should show comment" do
    get :show, id: @comment
    assert_response :success
    assert_select '.customer-picture', 'data-customer' => @comment.customer.id
    assert_select '.customer-picture', 'data-locality' => @comment.customer.locality
    assert_select '.customer-picture', 'data-created' => @comment.customer.created_at.strftime("%D")
  end

  test "should get edit" do
    get :edit, id: @comment
    assert_response :success
  end


  test "need login to edit comment" do
    sign_out :customer
    get :edit, id: @comment
    assert_redirected_to new_customer_session_path
  end

  test "should update comment" do
    sign_in :customer, (customers(:one))
    patch :update, id: @comment, comment: { description: @comment.description, product_id: @comment.product_id, score: @comment.score, title: @comment.title }
    assert_redirected_to comment_path(assigns(:comment))
  end

  test "need ownership to update comment" do
    sign_out :customer
    sign_in :customer, (customers(:two))
    patch :update, id: @comment, comment: { description: @comment.description, product_id: @comment.product_id, score: @comment.score, title: @comment.title }

    assert_redirected_to root_path
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete :destroy, id: @comment
    end

    assert_redirected_to comments_path
  end


end
