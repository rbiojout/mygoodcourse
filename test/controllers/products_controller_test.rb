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
    assert_equal session[:family_for_products_id].to_s, [categories(:one).family_id, categories(:two).family_id].to_s
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should filter catalog by category" do
    get :catalog, :category_id => (categories(:one))
    assert_equal session[:category_for_products_id], categories(:one).id.to_s
    assert_equal session[:family_for_products_id], [categories(:one).family_id]
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, short_description: @product.short_description, sku: @product.sku, :category_ids => [categories(:one)], :level_ids => [levels(:one)], attachments_attributes: {"0" =>{ file: fixture_file_upload('files/Sommaire.pdf', 'application/pdf')  }} }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should not create product without category" do
    assert_difference('Product.count', 0) do
      post :create, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, short_description: @product.short_description, sku: @product.sku, :category_ids => [], :level_ids => [levels(:one)], attachments_attributes: {"0" =>{ file: fixture_file_upload('files/Sommaire.pdf', 'application/pdf')  }} }
    end
  end

  test "should not create product without level" do
    assert_difference('Product.count', 0) do
      post :create, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, short_description: @product.short_description, sku: @product.sku, :category_ids => [categories(:one)], :level_ids => [], attachments_attributes: {"0" =>{ file: fixture_file_upload('files/Sommaire.pdf', 'application/pdf')  }} }
    end
  end

  test "should not create product without attachment" do
    assert_difference('Product.count', 0) do
      post :create, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, short_description: @product.short_description, sku: @product.sku, :category_ids => [categories(:one)], :level_ids => [levels(:one)], attachments_attributes: {"0" =>{ file: nil  }} }
    end
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
    @attachment = attachments(:one)
    patch :update, id: @product, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, short_description: @product.short_description, sku: @product.sku,
                                            attachments_attributes: { "0" =>{ id: attachments(:one).id } } }
    assert_redirected_to product_path(assigns(:product))
  end

  test "should update product with ordered attachments" do
    @attachment = attachments(:one)
    patch :update, id: @product, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, short_description: @product.short_description, sku: @product.sku,
                                            attachments_attributes: {
                                                "1465974930533" =>{ file: fixture_file_upload('files/Sommaire.pdf', 'application/pdf')},
                                                "0" =>{ id: attachments(:one).id } } }
    assert_equal 2, assigns(:product).attachments.count
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

  test "should buy" do
    assert_difference('OrderItem.count',1) do
      post :add_to_basket, product_id: products(:one)
    end
    assert_redirected_to catalog_products_path
  end

end
