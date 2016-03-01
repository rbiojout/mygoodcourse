class AddInfosToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :status, :string
    add_column :orders, :received_at, :datetime
    add_column :orders, :accepted_at, :datetime
    add_column :orders, :accepted_by, :integer
    add_column :orders, :consignment_number, :string
    add_column :orders, :rejected_at, :datetime
    add_column :orders, :rejected_by, :integer
    add_column :orders, :ip_address, :string
    add_column :orders, :notes, :text
    add_column :orders, :amount_paid, :decimal, precision: 8, scale: 2, default: 0.0
    add_column :orders, :exported, :boolean
    add_column :orders, :invoice_number, :string
    remove_column :orders, :order_date
  end
end
