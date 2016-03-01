class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :product, index: true, foreign_key: true
      t.decimal :price,           precision: 8, scale: 2
      t.decimal :tax_rate,        precision: 8, scale: 2
      t.decimal :tax_amount,      precision: 8, scale: 2
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
