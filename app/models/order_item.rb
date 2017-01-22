# == Schema Information
#
# Table name: order_items
#
#  id                   :integer          not null, primary key
#  product_id           :integer
#  price                :decimal(8, 2)    default(0.0)
#  tax_rate             :decimal(8, 2)
#  tax_amount           :decimal(8, 2)    default(0.0)
#  order_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  processing_reference :string
#  method               :string
#  status               :string
#  cost_price           :decimal(8, 2)    default(0.0)
#  application_fee      :decimal(8, 2)    default(0.0)
#
# Indexes
#
#  index_order_items_on_order_id    (order_id)
#  index_order_items_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_e3cb28f071  (order_id => orders.id)
#  fk_rails_f1a29ddd47  (product_id => products.id)
#

class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  # State Machine
  include AASM

  aasm column: 'status' do
    state :created, initial: true
    state :confirmed, :received, :accepted, :cashed_out, :rejected

    event :confirm do
      transitions from: :created, to: :confirmed
    end

    event :receive do
      transitions from: :confirmed, to: :received
    end

    event :accept do
      transitions from: :received, to: :accepted
    end

    event :cash_out do
      transitions from: :received, to: :cashed_out
    end

    event :reject do
      transitions from: [:confirmed, :received], to: :rejected
    end

    event :reset do
      transitions from: [:confirmed, :rejected, :received], to: :confirmed
    end
  end

  def run_init
    init_price(unit_price)
    save!
  end

  def init_price(value)
    self.price = value
    fee = (value * (COMMISSION_RATE / 100) + TRANSACTION_COST / 100) || BigDecimal(0)
    fee = 0.0 if value == 0.0 || fee < 0.0
    fee.round(2)
    self.application_fee = fee
    self.tax_rate = TAX_RATE
    self.tax_amount = (fee * TAX_RATE / 100).round(2)
    self.cost_price = value - application_fee
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
    # fail AppErrors::UnorderableItem, product: product unless product.active?
    if product.active
      transaction do
        if existing = where(product_id: product.id).first
          existing
        else
          # we will set
          # cost_price and application_fee only after create
          # unit_price is set during creation
          new_item = create(product: product, price: product.price)
          new_item
        end
      end
    end
  end

  after_create :run_init

  attr_accessor :unit_price

  # The unit price for the item
  # the price is for individual sellers, they don't pay the VAT
  # the VAT is only paid by the marketplace on the commission
  # @return [BigDecimal]
  def unit_price
    self[:unit_price] || (product.nil? ? BigDecimal(0) : product.price) || BigDecimal(0)
  end

  # The unit price for the item without tax
  # VAT tax is only on the commission
  # unit_price_without_tax = unit_price*( 1 - COMMISSION_RATE/100*TAX_RATE/100)
  #
  # @return [BigDecimal]
  def unit_price_without_tax
    unit_price - tax_amount
  end

  # The cost price for the item meaning the part for the seller
  # based on the price without tax and the commission rate
  # the VAT is only on the commission
  # unit_cost_price = unit_price(1 - COMMISSION_RATE/100*(1 + TAX_RATE/100) )
  #
  # @return [BigDecimal]
  def unit_cost_price
    self[:cost_price] || unit_price - application_fee
  end

  # The share of the seller
  # compared to the unit_price
  #
  # @return [BigDecimal]
  def share_seller
    if price == 0.0
      100.0
    else
      cost_price / price * 100
    end
  end

  # The application fee for the platfom
  # based on the unit cost price deducted from the unit price
  # application_fee = unit_price - unit_cost_price
  # includes the VAT paid by the Platform
  #
  # @return [BigDecimal]
  def application_fee
    self[:application_fee] || (unit_price * (COMMISSION_RATE / 100) + TRANSACTION_COST / 100).round(2) || BigDecimal(0)
  end

  # The tax rate for the item
  # the VAT is only on the commission
  #
  # @return [BigDecimal]
  def tax_rate
    self[:tax_rate] || TAX_RATE || product.try(:tax_rate).try(:rate_for, order) || BigDecimal(0)
  end

  # The total tax for the item
  # sub_total = amount with taxes
  # sub_total_without_tax = sub_total ( 1 - COMMISSION_RATE/100 * tax_rate/100)
  # tax_amout = sub_total - sub_total_without_tax = sub_total * (COMMISSION_RATE/100 * tax_rate/100) )
  #
  # @return [BigDecimal]
  def tax_amount
    self[:tax_amount] || (application_fee * tax_rate / 100)
  end

  # The total cost for the product
  # excluding VAT
  #
  # @return [BigDecimal]
  def total_cost
    # quantity * unit_cost_price
    unit_cost_price
  end

  # The sub total for the product
  # including commission and VAT
  #
  # @return [BigDecimal]
  def sub_total
    # quantity * unit_price
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

  # Application fee without tax
  #
  # @return [BigDecimal]
  def application_fee_without_tax
    application_fee * (1 -  tax_rate / 100)
  end
end
