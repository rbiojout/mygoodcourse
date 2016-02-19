class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.string :permalink
      t.string :description
      t.string :short_description
      t.boolean :active, default: true
      t.decimal :price, precision: 8, scale: 2, default: 0.0
      t.boolean :featured, default: false

      t.timestamps null: false
    end
  end
end
