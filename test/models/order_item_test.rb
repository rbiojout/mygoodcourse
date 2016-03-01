require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @order = orders(:order)
    @product = products(:yealink_t22p)
    @item = @order.order_items.create!(product: @product)
  end

  test 'new item can be added to order' do
    product2 = products(:snom_870)
    assert new_item = @order.order_items.add_item(product2)
    assert_equal true, new_item.is_a?(OrderItem)
    assert_equal product2, new_item.product
  end


  test 'financials' do
    assert_equal BigDecimal(100), @item.unit_price
    assert_equal ((1-COMMISSION_RATE/100)*100), @item.unit_cost_price
    assert_equal TAX_RATE, @item.tax_rate
    assert_equal (TAX_RATE/100 * 100), @item.tax_amount
    assert_equal ((1-COMMISSION_RATE/100)*100), @item.total_cost
    assert_equal BigDecimal(100), @item.sub_total
    assert_equal ((1 + TAX_RATE/100) * 100 ), @item.total
  end


  test 'that changes to a order items quantity after order confirmation updates stock allocation' do
    # get a user to mark the order as shipped
    user = customers(:JoeBloggs)
    assert @order.confirm!
    assert @order.accept!(user)
    assert @order.reload

    # the item we're going to use to test with
    item = @order.order_items.first

    assert item.save!
  end


end
