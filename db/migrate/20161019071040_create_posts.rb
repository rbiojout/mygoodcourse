class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.text :description
      t.references :customer, index: true, foreign_key: true
      t.integer :counter_cache, :default => 0

      t.timestamps null: false
    end
  end
end
