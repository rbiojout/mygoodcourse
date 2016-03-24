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


  test "should get catalog" do
    get :catalog
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should filter catalog by families" do
    get :catalog, :family_id => [families(:one).id.to_s, families(:two).id.to_s]
    assert_equal session[:family_for_products_id], [families(:one).id.to_s, families(:two).id.to_s]
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should filter catalog by family" do
    get :catalog, :family_id => (families(:one))
    assert_equal session[:family_for_products_id], families(:one).id.to_s
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should filter catalog by categories" do
    get :catalog, :category_id => [categories(:one).id.to_s, categories(:two).id.to_s]
    assert_equal session[:category_for_products_id], [categories(:one).id.to_s, categories(:two).id.to_s]
    assert_equal session[:family_for_products_id], [categories(:one).family_id, categories(:two).family_id].to_s
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should filter catalog by category" do
    get :catalog, :category_id => (categories(:one))
    assert_equal session[:category_for_products_id], categories(:one).id.to_s
    assert_equal session[:family_for_products_id], [categories(:one).family_id].to_s
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
