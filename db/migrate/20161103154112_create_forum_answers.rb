class CreateForumAnswers < ActiveRecord::Migration
  def change
    create_table :forum_answers do |t|
      t.text :text
      t.references :customer, index: true, foreign_key: true
      t.references :forum_subject, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
