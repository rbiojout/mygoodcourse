class AddCustomerToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :customer, index: true, foreign_key: true
  end
end
