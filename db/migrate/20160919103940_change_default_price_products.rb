class ChangeDefaultPriceProducts < ActiveRecord::Migration
  def change
    change_column_default :products, :price, 0
    Product.where("price is NUll").update_all(:price => 0)
  end
end
