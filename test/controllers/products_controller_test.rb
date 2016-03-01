require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @product = products(:one)
    # add a signed user to perform the tests
    sign_in :customer, (customers(:one))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, short_description: @product.short_description, sku: @product.sku, attachments_attributes: {"0" =>{ file: fixture_file_upload('files/Sommaire.pdf', 'application/pdf')  }} }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    patch :update, id: @product, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, short_description: @product.short_description, sku: @product.sku }
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product not ordered" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: products(:product_without_orders)
    end

    assert_redirected_to products_url
  end

  test "should not destroy product ordered" do
    assert_raises (ActiveRecord::DeleteRestrictionError) do
      delete :destroy, id: @product
    end
  end
end
