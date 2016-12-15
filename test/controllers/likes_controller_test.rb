require 'test_helper'

class LikesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  setup do
    @like = likes(:cust_one_prod_one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  test 'should not create like if not signed-in' do
    sign_out(customers(:one))
    assert_no_difference('Like.count') do
      post :like, like: {}, review_id: reviews(:one).id
    end

    assert_redirected_to new_customer_session_path
  end

  test 'should create like for review' do
    request.env['HTTP_REFERER'] = product_path(products(:one))
    assert_difference('Like.count') do
      post :like, like: {customer_id: customers(:one).id}, review_id: reviews(:one).id
    end

    assert_redirected_to product_path(products(:one))
  end

  test 'should create like for review via ajax' do
    sign_in(customers(:one), scope: :customer)
    assert_difference('Like.count') do
      xhr :post, :like, like: {customer_id: customers(:one).id}, review_id: reviews(:one).id
    end

    assert_response :success

    # assert_select 'like_review_'+reviews(:one).id.to_s
  end

  test 'should create like for Product' do
    request.env['HTTP_REFERER'] = product_path(products(:one))
    assert_difference('Like.count') do
      post :like, like: {customer_id: customers(:one).id}, product_id: products(:one).id
    end

    assert_redirected_to product_path(products(:one))
  end

  test 'should destroy like' do
    product = products(:two)
    request.env['HTTP_REFERER'] = product_path(product)
    post :like, product_id: products(:two).id

    assert product.liked?(customers(:one))

    request.env['HTTP_REFERER'] = product_path(product)
    assert_difference('Like.count', -1) do
      delete :unlike, product_id: products(:two).id
    end

    assert_not product.liked?(customers(:one))

    # assert_select 'like_review_'+reviews(:one).id.to_s
  end

  test 'should destroy like  via ajax' do
    product = products(:two)
    request.env['HTTP_REFERER'] = product_path(product)
    post :like, product_id: product.id

    assert product.liked?(customers(:one))

    request.env['HTTP_REFERER'] = product_path(product)
    assert_difference('Like.count', -1) do
      xhr :delete, :unlike, like: {customer_id: customers(:one).id}, product_id: product.id
    end

    assert_not product.liked?(customers(:one))
  end
end
