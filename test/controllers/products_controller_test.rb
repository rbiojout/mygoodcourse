require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @product = products(:one)
    # add a signed customer to perform the tests
    sign_in(customers(:one), scope: :customer)
  end

  test "should get index" do
    get :index, locale: I18n.default_locale
    assert_response :success
    assert_not_nil assigns(:products)
  end


  test "should get catalog" do
    get :catalog, locale: I18n.default_locale
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should filter catalog by families" do
    # set the country
    get :catalog, :country_id => (countries(:france)).id, locale: I18n.default_locale
    get :catalog, :family_id => [families(:one).id.to_s, families(:two).id.to_s], locale: I18n.default_locale
    assert_equal session[:family_for_products_id].sort, [families(:one).id.to_s, families(:two).id.to_s].sort
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should filter catalog by family" do
    # set the country
    get :catalog, :country_id => (countries(:france)).id, locale: I18n.default_locale
    get :catalog, :family_id => Array(families(:one)), locale: I18n.default_locale
    assert_equal session[:family_for_products_id], Array(families(:one).id.to_s)
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should filter catalog by categories" do
    # set the country
    get :catalog, :country_id => (countries(:france)).id, locale: I18n.default_locale
    get :catalog, :category_id => [categories(:one).id.to_s, categories(:two).id.to_s], locale: I18n.default_locale
    assert_equal session[:category_for_products_id].sort, [categories(:one).id.to_s, categories(:two).id.to_s].sort
    assert_equal session[:family_for_products_id].sort, [categories(:one).family_id, categories(:two).family_id].sort
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should filter catalog by category" do
    # set the country
    get :catalog, :country_id => (countries(:france)).id, locale: I18n.default_locale
    get :catalog, :category_id => Array(categories(:one)), locale: I18n.default_locale
    assert_equal session[:category_for_products_id], Array(categories(:one).id.to_s)
    assert_equal session[:family_for_products_id], [categories(:one).family_id]
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new, locale: I18n.default_locale
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, sku: @product.sku, :category_ids => [categories(:one)], :level_ids => [levels(:one)], attachments_attributes: {"0" =>{ file: fixture_file_upload('files/Sommaire.pdf', 'application/pdf')  }} }, locale: I18n.default_locale
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should not create product without category" do
    assert_difference('Product.count', 0) do
      post :create, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, sku: @product.sku, :category_ids => [], :level_ids => [levels(:one)], attachments_attributes: {"0" =>{ file: fixture_file_upload('files/Sommaire.pdf', 'application/pdf')  }} }, locale: I18n.default_locale
    end
  end

  test "should not create product without level" do
    assert_difference('Product.count', 0) do
      post :create, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, sku: @product.sku, :category_ids => [categories(:one)], :level_ids => [], attachments_attributes: {"0" =>{ file: fixture_file_upload('files/Sommaire.pdf', 'application/pdf')  }} }, locale: I18n.default_locale
    end
  end

  test "should not create product without attachment" do
    assert_difference('Product.count', 0) do
      post :create, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price,  sku: @product.sku, :category_ids => [categories(:one)], :level_ids => [levels(:one)], attachments_attributes: {"0" =>{ file: nil  }} }, locale: I18n.default_locale
    end
  end


  test "should show product" do
    get :show, id: @product, locale: I18n.default_locale
    assert_response :success
  end

  test "should impression show product" do
    product = products(:one)
    assert_difference ('product.counter_cache') do
      # @TODO why needed double?
      get :show, locale: I18n.default_locale, id: product
      get :show, locale: I18n.default_locale, id: product
      product = assigns(:product)
    end
  end


  test "should show product with slug" do
    get :show, id: @product.slug, locale: I18n.default_locale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product, locale: I18n.default_locale
    assert_response :success
  end

  test "should get edit with slug" do
    get :edit, id: @product.slug, locale: I18n.default_locale
    assert_response :success
  end

  test "should update product" do
    @attachment = attachments(:one)
    patch :update, id: @product, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, sku: @product.sku,
                                            attachments_attributes: { "0" =>{ id: attachments(:one).id } } }, locale: I18n.default_locale

    assert_redirected_to product_path(assigns(:product))
  end

  test "should update product with ordered attachments" do
    @attachment = attachments(:one)
    patch :update, id: @product, product: { active: @product.active, description: @product.description, name: @product.name, permalink: @product.permalink, price: @product.price, sku: @product.sku,
                                            attachments_attributes: {
                                                "1465974930533" =>{ file: fixture_file_upload('files/Sommaire.pdf', 'application/pdf')},
                                                "0" =>{ id: attachments(:one).id } } }, locale: I18n.default_locale
    assert_equal 2, assigns(:product).attachments.count
  end

  test "should destroy product not ordered" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: products(:product_without_orders), locale: I18n.default_locale
    end

    assert_redirected_to products_url
  end

  test "should not destroy product ordered" do
    assert_raises (ActiveRecord::DeleteRestrictionError) do
      delete :destroy, id: @product, locale: I18n.default_locale
    end
  end

  test "should buy" do
    assert_difference('OrderItem.count',1) do
      post :add_to_basket, product_id: products(:one), locale: I18n.default_locale
    end
    assert_redirected_to catalog_products_path
  end

  test "should buy with slug" do
    assert_difference('OrderItem.count',1) do
      post :add_to_basket, product_id: products(:one).slug, locale: I18n.default_locale
    end
    assert_redirected_to catalog_products_path
  end

  test "should see download is owner" do
    sign_in(customers(:seller_one), scope: :customer)
    product = products(:one_from_seller_one)

    get :show, id: product, locale: I18n.default_locale

    assert_select "#product_download a[href=?]", product.file_url
  end

  test "should see edit if owned" do
    customer = customers(:seller_one)
    sign_in(customer, scope: :customer)
    product = products(:one_from_seller_one)

    get :show, id: product, locale: I18n.default_locale

    assert customer.own_product(product)
    assert_select "#product_actions a[href=?]", edit_product_path(product)

    customer = customers(:buyer_one)
    sign_in(customer, scope: :customer)



  end

  test "should see add to cart is not signed" do
    product = products(:one_from_seller_one)

    get :show, id: product, locale: I18n.default_locale

    assert_select "#product_actions a[href=?]", buy_product_path(product)
    assert_select "#product_actions a[data-method=?]", "post"
  end

end
