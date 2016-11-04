class CreateForumFamilies < ActiveRecord::Migration
  def change
    create_table :forum_families do |t|
      t.string :name
      t.text :description
      t.string :visual
      t.references :country, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
