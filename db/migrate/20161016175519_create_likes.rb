class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :customer, index: true, foreign_key: true
      t.references :likeable, index: true, polymorphic: true

      t.timestamps null: false
    end
  end
end
