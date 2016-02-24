class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false, index: true
      t.string :description
      t.references :family, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
