require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  before do
    @order = orders(:order)
    @product = products(:priced_one)
    @item = @order.order_items.create!(product: @product)
  end

  context 'validation' do
    it 'new item can be added to order' do
      product2 = products(:priced_two)
      new_item = @order.order_items.add_item(product2)
      expect(new_item).not_to be_nil
      expect(new_item.is_a?(OrderItem)).to be_truthy
      expect(product2).to eq(new_item.product)
      expect(product2.price).to eq(new_item.price)
    end

    # with VAT = TAX_RATE
    # with commission_rate = COMMISSION_RATE
    it 'financials' do
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

    it 'add item' do
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

    it 'that changes to a order items quantity after order confirmation updates stock allocation' do
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

    it 'should be associated to orders' do
      expect(OrderItem.find_ordered_by_customer(customers(:one).id)).not_to be_empty
      # @TODO verify the status
    end

    it 'bought by customer' do
      # we need an OrderItem with a status 'accepted'
      @item.status = 'accepted'
      @item.save!
      # we need a customer to have bought the product
      customer = customers(:one)
      @order.customer = customer
      @order.save!
      expect(OrderItem.find_bought_by_customer(customer.id)).not_to be_empty
      # we must have the product available for the customer
      expect(Product.find_bought_by_customer(customer.id)).not_to be_empty
    end

    it 'sold by customer' do
      customer = customers(:one)
      expect(OrderItem.find_sold_by_customer(customer.id)).not_to be_empty
    end
  end
end
