require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @review = reviews(:one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:reviews)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create review' do
    assert_difference('Review.count') do
      post :create, review: {description: @review.description, product_id: @review.product_id, score: @review.score, title: @review.title}
    end

    assert_redirected_to review_path(assigns(:review))
  end

  test 'should create review via ajax' do
    sign_in(customers(:one), scope: :customer)
    assert_difference('Review.count') do
      xhr :post, :create, review: {description: @review.description, product_id: @review.product_id, score: @review.score, title: @review.title}
    end

    assert_response :success
  end

  test 'need login to create review' do
    sign_out :customer
    assert_no_difference('Review.count') do
      post :create, review: {description: @review.description, product_id: @review.product_id, score: @review.score, title: @review.title}
    end

    assert_redirected_to new_customer_session_path
  end

  test 'should show review' do
    get :show, id: @review
    assert_response :success
    assert_select '.customer-picture', 'data-customer' => @review.customer.id
    assert_select '.customer-picture', 'data-locality' => @review.customer.locality
    assert_select '.customer-picture', 'data-created' => @review.customer.created_at.strftime('%D')
  end

  test 'should get edit' do
    get :edit, id: @review
    assert_response :success
  end

  test 'need login to edit review' do
    sign_out :customer
    get :edit, id: @review
    assert_redirected_to new_customer_session_path
  end

  test 'should update review' do
    sign_in(customers(:one), scope: :customer)
    patch :update, id: @review, review: {description: @review.description, product_id: @review.product_id, score: @review.score, title: @review.title}
    assert_redirected_to review_path(assigns(:review))
  end

  test 'need ownership to update review' do
    sign_out :customer
    sign_in(customers(:two), scope: :customer)
    patch :update, id: @review, review: {description: @review.description, product_id: @review.product_id, score: @review.score, title: @review.title}

    assert_redirected_to catalog_products_path
  end

  test 'should destroy review' do
    assert_difference('Review.count', -1) do
      delete :destroy, id: @review
    end

    assert_redirected_to reviews_path
  end
end
