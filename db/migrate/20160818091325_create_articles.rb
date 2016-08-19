class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :name
      t.text :description
      t.integer :position
      t.integer :visits
      t.string :slug
      t.references :topic, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
