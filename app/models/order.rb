class Order < ActiveRecord::Base

  EMAIL_REGEX = /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i
  PHONE_REGEX = /\A[+?\d\ \-x\(\)]{7,}\z/

  self.table_name = 'orders'


  # Require dependencies
  require_dependency 'order/states'
  require_dependency 'order/actions'
  require_dependency 'order/billing'
  #require_dependency 'shoppe/order/delivery'


  # the customer linked to the order
  belongs_to :customer

  # All items which make up this order
  has_many :order_items, dependent: :destroy


  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: proc { |a| a['ordered_item_id'].blank? }

  # All products which are part of this order (accessed through the items)
  # We don't want to delete if some orders have been done
  has_many :products, through: :order_items, dependent: :restrict_with_exception

  # Set some defaults
  before_validation { self.token = SecureRandom.uuid  if token.blank? }

  # Some methods for setting the billing & delivery addresses
  attr_accessor :save_addresses, :billing_address_id, :delivery_address_id

  # This search the orders with a state 'accepted' for a particular customer_id
  # the collection is ordered by creation date descending
  scope :accepted_for_customer, -> (customer_id) {where(:customer_id => customer_id, status: ['received', 'accepted']).order(:created_at => :desc)}

  # The order number
  #
  # @return [String] - the order number padded with at least 5 zeros
  def number
    id ? id.to_s.rjust(9, '0') : nil
  end

  # The length of time the customer spent building the order before submitting it to us.
  # The time from first item in basket to received.
  #
  # @return [Float] - the length of time
  def build_time
    return nil if received_at.blank?
    created_at - received_at
  end

  # Is this order empty? (i.e. doesn't have any items associated with it)
  #
  # @return [Boolean]
  def empty?
    order_items.empty?
  end

  # Does this order have items?
  #
  # @return [Boolean]
  def has_items?
    total_items > 0
  end

  # Return the number of items in the order?
  #
  # @return [Integer]
  def total_items
    order_items.inject(0) { |t, i| t + 1 }
  end


end
