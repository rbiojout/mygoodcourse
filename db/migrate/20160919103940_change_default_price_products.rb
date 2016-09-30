class ChangeDefaultPriceProducts < ActiveRecord::Migration
  def self.up
    change_column_default :products, :price, 0
    Product.where("price is NUll").update_all(:price => 0)
  end

  def self.down
    change_column_default :products, :price, nil
    Product.where("price = 0").update_all(:price => nil)
  end


end
