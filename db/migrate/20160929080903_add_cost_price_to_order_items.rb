class AddCostPriceToOrderItems < ActiveRecord::Migration
  def self.up
    add_column :order_items, :cost_price, :decimal, precision: 8, scale: 2, default: 0.0
    add_column :order_items, :application_fee, :decimal, precision: 8, scale: 2, default: 0.0
    change_column_default :order_items, :price, 0
    OrderItem.where("price is NUll").update_all(:price => 0)
    change_column_default :order_items, :tax_amount, 0
    OrderItem.where("tax_amount is NUll").update_all(:tax_amount => 0)
  end

  def self.down
    remove_column :order_items, :cost_price
    remove_column :order_items, :application_fee
    change_column_default :order_items, :price, nil
    OrderItem.where("price = 0").update_all(:price => nil)
    change_column_default :order_items, :tax_amount, nil
    OrderItem.where("tax_amount = 0").update_all(:tax_amount => nil)
  end

end
