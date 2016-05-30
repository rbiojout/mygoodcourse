class AddDetailsToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :processing_reference, :string
    add_column :order_items, :method, :string
    add_column :order_items, :status, :string
  end
end
