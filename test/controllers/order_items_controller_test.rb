require 'test_helper'

class OrderItemsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @order_item = order_items(:one)
  end

  test "should create order_item" do
    assert_difference('OrderItem.count') do
      post :create, order_item: { order_id: @order_item.order_id, price: @order_item.price, product_id: @order_item.product_id, tax_amount: @order_item.tax_amount, tax_rate: @order_item.tax_rate }
    end
  end


  test "should update order_item" do
    patch :update, id: @order_item, order_item: { order_id: @order_item.order_id, price: @order_item.price, product_id: @order_item.product_id, tax_amount: @order_item.tax_amount, tax_rate: @order_item.tax_rate }
    assert /\A\s*\z/.match(@response.body)
  end

  test "should destroy order_item" do
    assert_difference('OrderItem.count', -1) do
      delete :destroy, :format => 'js', id: @order_item
    end

    #assert /\A\s*\z/.match(@response.body)
  end
end
