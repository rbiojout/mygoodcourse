require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  # test 'the truth' do
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
    assert_equal product2.price, new_item.price
  end

  # with VAT = TAX_RATE
  # with commission_rate = COMMISSION_RATE
  test 'financials' do
    new_item = @order.order_items.add_item(@product)
    assert_equal BigDecimal(100), @item.unit_price
    assert_equal 100 - (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2) * TAX_RATE / 100,
                 new_item.unit_price_without_tax
    assert_equal 100 - (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2),
                 new_item.unit_cost_price
    assert_equal TAX_RATE, new_item.tax_rate
    assert_equal (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2) * TAX_RATE / 100,
                 new_item.tax_amount
    assert_equal 100 - (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2),
                 new_item.total_cost
    assert_equal BigDecimal(100), new_item.sub_total
    assert_equal 100, new_item.total
  end

  test 'add item' do
    new_item = @order.order_items.create!(product: @product)
    assert_equal BigDecimal(100), @item.unit_price
    assert_equal 100 - (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2) * TAX_RATE / 100,
                 new_item.unit_price_without_tax
    assert_equal 100 - (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2),
                 new_item.unit_cost_price
    assert_equal TAX_RATE, new_item.tax_rate
    assert_equal (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2) * TAX_RATE / 100,
                 new_item.tax_amount
    assert_equal 100 - (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2),
                 new_item.total_cost
    assert_equal BigDecimal(100), new_item.sub_total
    assert_equal 100, new_item.total
  end

  test 'that changes to a order items quantity after order confirmation updates stock allocation' do
    # get a user to mark the order as ok
    @order.confirm!
    assert @order.confirmed?
    @order.receive!
    assert @order.received?
    @order.reject!
    assert @order.rejected?

    # the item we're going to use to test with
    item = @order.order_items.first

    assert item.save!
  end

  test 'should be associated to orders' do
    assert_not_empty OrderItem.find_ordered_by_customer(customers(:one).id)
    # @TODO verify the status
  end

  test 'bought by customer' do
    # we need an OrderItem with a status 'accepted'
    @item.status = 'accepted'
    @item.save!
    # we need a customer to have bought the product
    customer = customers(:one)
    @order.customer = customer
    @order.save!
    assert_not_empty OrderItem.find_bought_by_customer(customer.id)
    # we must have the product available for the customer
    assert_not_empty Product.find_bought_by_customer(customer.id)
  end

  test 'sold by customer' do
    customer = customers(:one)
    assert_not_empty OrderItem.find_sold_by_customer(customer.id)
  end
end
