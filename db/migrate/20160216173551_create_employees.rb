class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :first_name
      t.date :entry_date
      t.string :mobile
      t.string :picture
      t.string :role
      t.boolean :active

      t.timestamps null: false
    end
  end
end
