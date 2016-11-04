class CreateForumSubjects < ActiveRecord::Migration
  def change
    create_table :forum_subjects do |t|
      t.string :name
      t.text :text
      t.references :customer, index: true, foreign_key: true
      t.references :forum_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
