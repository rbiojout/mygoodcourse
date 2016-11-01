require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @comment = comments(:one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  test "should get new for Post" do
    get :new, post_id: posts(:one).id
    assert_response :success
  end

  test "should create comment for Post" do
    assert_difference('Comment.count') do
      post :create, post_id: posts(:one).id, comment: { commentable_id: @comment.commentable_id, customer_id: @comment.customer_id, text: @comment.text }
    end

    assert_redirected_to post_path(posts(:one))
  end

  test "should show comment for Post" do
    get :show, id: @comment
    assert_redirected_to post_path(posts(:one))
  end

  test "should get edit for Post" do
    get :edit, id: @comment, post_id: posts(:one).id
    assert_response :success
  end

  test "should create comment for Post via ajax" do
    sign_in(customers(:one), scope: :customer)
    assert_difference('Comment.count') do
      xhr :post, :create, post_id: posts(:one).id, comment: { commentable_id: @comment.commentable_id, customer_id: @comment.customer_id, text: @comment.text }
    end

    assert_response :success

  end

  test "should update comment for Post" do
    patch :update, post_id: posts(:one).id, id: @comment, comment: { commentable_id: @comment.commentable_id, customer_id: @comment.customer_id, text: @comment.text }
    assert_redirected_to post_path(posts(:one))
  end

  test "should update comment for Post via ajax" do
    sign_in(customers(:one), scope: :customer)
    patch :update, xhr: true, post_id: posts(:one).id, id: @comment, comment: { commentable_id: @comment.commentable_id, customer_id: @comment.customer_id, text: @comment.text }


  end

  test "should destroy comment for Post" do
    assert_difference('Comment.count', -1) do
      delete :destroy, id: @comment, post_id: posts(:one).id
    end

    assert_redirected_to post_path(posts(:one))
  end
end
