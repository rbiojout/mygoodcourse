require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @order = orders(:order)
    @product = products(:priced_one)
    @item = @order.order_items.create!(product: @product)
  end

  test 'new item can be added to order' do
    product2 = products(:priced_two)
    assert new_item = @order.order_items.add_item(product2)
    assert_equal true, new_item.is_a?(OrderItem)
    assert_equal product2, new_item.product
  end


  # with VAT = TAX_RATE
  # with commission_rate = COMMISSION_RATE
  test 'financials' do
    assert_equal BigDecimal(100), @item.unit_price
    assert_equal BigDecimal(100*(1-COMMISSION_RATE/100*TAX_RATE/100)), @item.unit_price_without_tax
    assert_equal (100*(1-COMMISSION_RATE/100*(1+TAX_RATE/100))), @item.unit_cost_price
    assert_equal TAX_RATE, @item.tax_rate
    assert_equal 100*(TAX_RATE/100 * COMMISSION_RATE/100), @item.tax_amount
    assert_equal (100*(1-COMMISSION_RATE/100*(1+TAX_RATE/100))), @item.total_cost
    assert_equal BigDecimal(100), @item.sub_total
    assert_equal (100), @item.total
  end

  test 'add item' do
    new_item = OrderItem.add_item(@product)
    assert_equal BigDecimal(100), new_item.unit_price
    assert_equal BigDecimal(100*(1-COMMISSION_RATE/100*TAX_RATE/100)), new_item.unit_price_without_tax
    assert_equal (100*(1-COMMISSION_RATE/100*(1+TAX_RATE/100))), new_item.unit_cost_price
    assert_equal TAX_RATE, new_item.tax_rate
    assert_equal 100*(TAX_RATE/100 * COMMISSION_RATE/100), new_item.tax_amount
    assert_equal (100*(1-COMMISSION_RATE/100*(1+TAX_RATE/100))), new_item.total_cost
    assert_equal BigDecimal(100), new_item.sub_total
    assert_equal (100), new_item.total
  end


  test 'that changes to a order items quantity after order confirmation updates stock allocation' do
    # get a user to mark the order as ok
    user = customers(:JoeBloggs)
    assert @order.confirm!
    assert @order.accept!(user)
    assert @order.reload

    # the item we're going to use to test with
    item = @order.order_items.first

    assert item.save!
  end


end
