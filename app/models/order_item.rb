class OrderItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :order

  # State Machine
  include AASM

  aasm :column => 'status' do
    state :created, :initial => true
    state :confirmed, :received, :accepted, :cashed_out, :rejected

    event :confirm do
      transitions :from => :created, :to => :confirmed
    end

    event :receive do
      transitions :from => :confirmed, :to => :received
    end

    event :accept do
      transitions :from => :received, :to => :accepted
    end

    event :cash_out do
      transitions :from => :received, :to => :cashed_out
    end

    event :reject do
      transitions :from => [:confirmed, :received], :to => :rejected
    end

    event :reset do
      transitions :from => [:confirmed, :rejected, :received], :to => :confirmed
    end


  end


  # Recover all accepted order_items received for a particular customers buying
  # @param customer_id [int] the id for the seller
  # @param status [String] the status state, default 'accepted'
  # @return [Collection]
  def self.find_ordered_by_customer(customer_id, status = 'accepted')
    status = Order::STATUSES.include?(status) ? status : 'accepted'
    OrderItem.joins(:order).where(orders: {status: status, customer_id: customer_id}).order(:product_id)
  end

  # Recover all accepted order_items received for a particular customers buying
  # @param customer_id [int] the id for the seller
  # @return [Collection]
  def self.find_bought_by_customer(customer_id)
    OrderItem.joins(:order).where(orders: {status: 'accepted', customer_id: customer_id}).order(:product_id)
  end

  # Recover all accepted order_items received for a particular customers selling
  # @param customer_id [int] the id for the seller
  # @param status [String] the status state, default 'accepted'
  # @return [Collection]
  def self.find_sold_by_customer(customer_id, status = 'accepted')
    status = Order::STATUSES.include?(status) ? status : 'accepted'
    joins(:order).where(orders: {status: status}).joins(:product).where(products: {customer_id: customer_id}).order(:product_id)
  end

  # This allows you to add a product to the scoped order. For example Order.first.order_items.add_product(...).
  # This will either increase the quantity of the value in the order or create a new item if one does not
  # exist already.
  #
  # @param ordered_item [Object] an object which implements the Shoppe::OrderableItem protocol
  # @return [OrderItem]
  def self.add_item(product)
    #fail Errors::UnorderableItem, product: product unless product.active?
    if product.active
      transaction do
        if existing = where(product_id: product.id).first
          existing
        else
          new_item = create(product: product, price: product.price || 0.00 , tax_rate: TAX_RATE, tax_amount: ((product.price|| 0.00) * (COMMISSION_RATE/100) * (TAX_RATE/100))   )
          new_item
        end
      end
    else
      # @TODO treat it
      #raise "inactive product"
    end
  end


  # The unit price for the item
  # the price is for individual sellers, they don't pay the VAT
  # the VAT is only paid by the marketplace on the commission
  # @return [BigDecimal]
  def unit_price
    read_attribute(:unit_price) || product.price || BigDecimal(0)
  end

  # The unit price for the item without tax
  # VAT tax is only on the commission
  # unit_price_without_tax = unit_price*( 1 - COMMISSION_RATE/100*TAX_RATE/100)
  #
  # @return [BigDecimal]
  def unit_price_without_tax
    read_attribute(:unit_price_without_tax) || product.price*(1-COMMISSION_RATE/100*TAX_RATE/100) || BigDecimal(0)
  end


  # The cost price for the item meaning the part for the seller
  # based on the price without tax and the commission rate
  # the VAT is only on the commission
  # unit_cost_price = unit_price(1 - COMMISSION_RATE/100*(1 + TAX_RATE/100) )
  #
  # @return [BigDecimal]
  def unit_cost_price
    read_attribute(:cost_price) || unit_price*(1-COMMISSION_RATE/100*(1+TAX_RATE/100)) || BigDecimal(0)
  end

  # The application fee for the platfom
  # based on the unit cost price deducted from the unit price
  # application_fee = unit_price - unit_cost_price
  #
  # @return [BigDecimal]
  def application_fee
    unit_price - unit_cost_price || BigDecimal(0)
  end

  # The tax rate for the item
  # the VAT is only on the commission
  #
  # @return [BigDecimal]
  def tax_rate
    read_attribute(:tax_rate) || TAX_RATE || product.try(:tax_rate).try(:rate_for, order) || BigDecimal(0)
  end

  # The total tax for the item
  # sub_total = amount with taxes
  # sub_total_without_tax = sub_total ( 1 - COMMISSION_RATE/100 * tax_rate/100)
  # tax_amout = sub_total - sub_total_without_tax = sub_total * (COMMISSION_RATE/100 * tax_rate/100) )
  #
  # @return [BigDecimal]
  def tax_amount
    read_attribute(:tax_amount) || (sub_total * (COMMISSION_RATE/100) * (tax_rate/100))
  end

  # The total cost for the product
  # excluding VAT
  #
  # @return [BigDecimal]
  def total_cost
    #quantity * unit_cost_price
    unit_cost_price
  end

  # The sub total for the product
  # including commission and VAT
  #
  # @return [BigDecimal]
  def sub_total
    #quantity * unit_price
    unit_price
  end

  # The total price including tax for the order line and the commission
  #
  # @return [BigDecimal]
  def total
    sub_total
  end

  # The total price including tax for the order line
  #
  # @return [BigDecimal]
  def total_without_tax
     sub_total - tax_amount
  end

end
