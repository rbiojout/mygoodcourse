# == Schema Information
#
# Table name: orders
#
#  id                 :integer          not null, primary key
#  customer_id        :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  token              :string
#  status             :string
#  received_at        :datetime
#  accepted_at        :datetime
#  accepted_by        :integer
#  consignment_number :string
#  rejected_at        :datetime
#  rejected_by        :integer
#  ip_address         :string
#  notes              :text
#  amount_paid        :decimal(8, 2)    default(0.0)
#  exported           :boolean
#  invoice_number     :string
#
# Indexes
#
#  index_orders_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_3dad120da9  (customer_id => customers.id)
#

class Order < ActiveRecord::Base
  EMAIL_REGEX = /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i
  PHONE_REGEX = /\A[+?\d\ \-x\(\)]{7,}\z/

  self.table_name = 'orders'

  # virtual attribute
  attr_accessor :stripe_customer_token

  # Require dependencies
  require_dependency 'order/states'
  require_dependency 'order/billing'
  require_dependency 'order/stripe_order'

  # The Employee who accepted the order
  #
  # @return [Customer]
  belongs_to :customer

  # The Employee who accepted the order
  #
  # @return [Employee]
  belongs_to :accepter, class_name: 'Employee', foreign_key: 'accepted_by'

  # The Employee who rejected the order
  #
  # @return [Employee]
  belongs_to :rejecter, class_name: 'Employee', foreign_key: 'rejected_by'

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

  # This search the orders for a particular customer_id
  # the collection is ordered by creation date descending
  scope :for_customer, ->(customer_id) { where(customer_id: customer_id).order(created_at: :desc) }

  # This search the orders with a state 'accepted' for a particular customer_id
  # the collection is ordered by creation date descending
  scope :accepted_for_customer, ->(customer_id) { where(customer_id: customer_id, status: %w(accepted)).order(created_at: :desc) }

  # All orders which have been accepted
  scope :accepted, -> { where(status: 'accepted') }

  # All orders which have been rejected
  scope :rejected, -> { where(status: 'rejected') }

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
    total_items.positive?
  end

  # Return the number of items in the order?
  #
  # @return [Integer]
  def total_items
    order_items.inject(0) { |t, _i| t + 1 }
  end
end
