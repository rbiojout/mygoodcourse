require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'a completely clean new order' do
    # order = orders(:one)
    order = Order.create
    assert_equal true, order.created?
    assert_equal false, order.received?
    assert_equal true, order.empty?
    assert_equal 0, order.total_items
    assert_equal false, order.has_items?
    assert_match /\A\d{9}\z/, order.number
    assert_match /\A[a-f0-9\-]{36}\z/, order.token

    assert_equal 0.0, order.total_cost
    assert_equal 0.0, order.profit
    assert_equal 0.0, order.total_before_tax
    assert_equal 0.0, order.tax
    assert_equal 0.0, order.total
    assert_equal 0.0, order.balance

    assert_equal false, order.payment_outstanding?
    assert_equal true, order.paid_in_full?
    assert_equal false, order.invoiced?
  end

  test 'money calculations' do
    # create some products with some stock (so it doesn't get in our way)
    product1 = products(:priced_one)
    product2 = products(:priced_two)

    # create an order
    order = orders(:order)

    # check order items
    assert_equal false, order.has_items?
    assert_equal true, order.empty?

    # add the first item
    item1 = order.order_items.create!(product: product1)

    # check all prices for the first item
    assert_equal BigDecimal(100), item1.unit_price
    assert_equal 100 - (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2) * TAX_RATE / 100,
                 item1.unit_price_without_tax
    assert_equal 100 - (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2),
                 item1.unit_cost_price
    assert_equal TAX_RATE, item1.tax_rate
    assert_equal (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2) * (TAX_RATE / 100),
                 item1.tax_amount
    assert_equal 100 - (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2),
                 item1.total_cost
    assert_equal BigDecimal(100), item1.sub_total
    assert_equal BigDecimal(100), item1.total

    # check that no item prices have been persisted
    assert_equal nil, item1.read_attribute(:unit_price)
    assert_equal nil, item1.read_attribute(:unit_cost_price)

    # check the order's totals are looking OK
    assert_equal BigDecimal(100), order.items_sub_total
    assert_equal 100 - (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2) * TAX_RATE / 100,
                 item1.unit_price_without_tax
    assert_equal (100 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2) * TAX_RATE / 100,
                 order.tax
    assert_equal BigDecimal(100), order.total

    # check the item totals are OK
    assert_equal 1, order.total_items
    assert_equal true, order.has_items?
    assert_equal false, order.empty?

    # add another item
    item2 = order.order_items.create!(product: product2)

    # check all prices for the second item

    assert_equal BigDecimal(200), item2.unit_price
    assert_equal 200 - (200 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2) * TAX_RATE / 100,
                 item2.unit_price_without_tax
    assert_equal 200 - (200 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2),
                 item2.unit_cost_price
    assert_equal (200 * COMMISSION_RATE / 100 + TRANSACTION_COST / 100).round(2) * TAX_RATE / 100,
                 item2.tax_amount
    assert_equal TAX_RATE, item2.tax_rate
    assert_equal BigDecimal(200), item2.sub_total
    assert_equal BigDecimal(200), item2.total

    # check item total again
    assert_equal 2, order.total_items

    # check order totals again
    assert_equal BigDecimal(300), order.items_sub_total
    # this is for 2 products, one at 100 and one at 200
    assert_equal (300 * COMMISSION_RATE / 100 + 2 * TRANSACTION_COST / 100).round(2) * TAX_RATE / 100,
                 order.tax
    assert_equal BigDecimal(300), order.total
  end
end
