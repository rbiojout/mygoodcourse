class CreateWishLists < ActiveRecord::Migration
  def change
    create_table :wish_lists do |t|
      t.references :customer, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
