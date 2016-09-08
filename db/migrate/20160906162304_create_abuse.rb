class CreateAbuse < ActiveRecord::Migration
  def change
    create_table :abuses do |t|
      t.references :abusable, polymorphic: true, index: true
      t.references :customer, index: true, foreign_key: true
      t.text :description
      t.string :status
    end
  end
end
