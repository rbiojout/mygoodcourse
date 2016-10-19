require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @post = posts(:one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not get new if not identified" do
    sign_out(customers(:one))
    get :new, locale: I18n.default_locale
    assert_response :found
    assert_redirected_to new_customer_session_path
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, post: { customer_id: @post.customer_id, description: @post.description, name: @post.name }
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should not create post if not identified" do
    sign_out(customers(:one))
    post :create, post: { customer_id: @post.customer_id, description: @post.description, name: @post.name }
    assert_response :found
    assert_redirected_to new_customer_session_path
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should show post with slug" do
    get :show, id: @post.slug, locale: I18n.default_locale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post
    assert_response :success
  end

  test "should get edit with slug" do
    get :edit, id: @post.slug, locale: I18n.default_locale
    assert_response :success
  end

  test "should get edit if not identified" do
    sign_out(customers(:one))
    get :edit, id: @post
    assert_response :found
    assert_redirected_to new_customer_session_path
  end

  test "should not get edit if not post owner" do
    sign_out(customers(:one))
    sign_in(customers(:two), scope: :customer)
    get :edit, id: @post.slug, locale: I18n.default_locale

    assert_response :found
    assert_redirected_to posts_path, locale: I18n.default_locale
  end

  test "should update post" do
    patch :update, id: @post, post: { customer_id: @post.customer_id, description: @post.description, name: @post.name }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should not update post if not identified" do
    sign_out(customers(:one))
    patch :update, id: @post, post: { customer_id: @post.customer_id, description: @post.description, name: @post.name }
    assert_response :found
    assert_redirected_to new_customer_session_path
  end

  test "should not get update if not post owner" do
    sign_out(customers(:one))
    sign_in(customers(:two), scope: :customer)
    patch :update, id: @post, post: { customer_id: @post.customer_id, description: @post.description, name: @post.name }
    assert_response :found
    assert_redirected_to posts_path, locale: I18n.default_locale
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end

  test "should not destroy post if not identified" do
    sign_out(customers(:one))
    delete :destroy, id: @post
    assert_response :found
    assert_redirected_to new_customer_session_path
  end

  test "should not destroy post if not post owner" do
    sign_out(customers(:one))
    sign_in(customers(:two), scope: :customer)
    delete :destroy, id: @post
    assert_response :found
    assert_redirected_to posts_path, locale: I18n.default_locale
  end

end
