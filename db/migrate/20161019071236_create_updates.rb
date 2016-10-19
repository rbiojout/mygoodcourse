class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :name
      t.text :description
      t.references :customer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
