class CreateForumCategories < ActiveRecord::Migration
  def change
    create_table :forum_categories do |t|
      t.string :name
      t.text :description
      t.string :visual
      t.references :forum_family, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
