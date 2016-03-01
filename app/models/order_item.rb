class OrderItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :order

  # Before saving an order item which belongs to a received order, cache the pricing again if appropriate.
  before_save do
    if order.received? && (price_changed? )
      cache_pricing
    end
  end


  # This allows you to add a product to the scoped order. For example Order.first.order_items.add_product(...).
  # This will either increase the quantity of the value in the order or create a new item if one does not
  # exist already.
  #
  # @param ordered_item [Object] an object which implements the Shoppe::OrderableItem protocol
  # @param quantity [Fixnum] the number of items to order
  # @return [Shoppe::OrderItem]
  def self.add_item(product)
    fail Errors::UnorderableItem, product: product unless product.active?
    transaction do
      if existing = where(product_id: product.id).first
        existing
      else
        new_item = create(product: product)
        new_item
      end
    end
  end


  # The unit price for the item
  #
  # @return [BigDecimal]
  def unit_price
    read_attribute(:price) || product.try(:price) || BigDecimal(0)
  end

  # The cost price for the item
  #
  # @return [BigDecimal]
  def unit_cost_price
    read_attribute(:cost_price) || ((1-COMMISSION_RATE/100) * unit_price) || BigDecimal(0)
  end

  # The tax rate for the item
  #
  # @return [BigDecimal]
  def tax_rate
    logger.debug ("ENV['TAX_RATE'] #{ENV['TAX_RATE']}  #{'TAX_RATE'}")
    read_attribute(:tax_rate) || TAX_RATE || product.try(:tax_rate).try(:rate_for, order) || BigDecimal(0)
  end

  # The total tax for the item
  #
  # @return [BigDecimal]
  def tax_amount
    read_attribute(:tax_amount) || (sub_total / BigDecimal(100)) * tax_rate
  end

  # The total cost for the product
  #
  # @return [BigDecimal]
  def total_cost
    #quantity * unit_cost_price
    unit_cost_price
  end

  # The sub total for the product
  #
  # @return [BigDecimal]
  def sub_total
    #quantity * unit_price
    unit_price
  end

  # The total price including tax for the order line
  #
  # @return [BigDecimal]
  def total
    tax_amount + sub_total
  end

  # Cache the pricing for this order item
  def cache_pricing
    write_attribute :price, price
  end

  # Cache the pricing for this order item and save
  def cache_pricing!
    cache_pricing
    save!
  end

  # Trigger when the associated order is confirmed. It handles caching the values
  # of the monetary items and allocating stock as appropriate.
  def confirm!
    cache_pricing!
  end

  # Trigger when the associated order is accepted
  def accept!
  end

  # Trigged when the associated order is rejected..
  def reject!
  end


end
