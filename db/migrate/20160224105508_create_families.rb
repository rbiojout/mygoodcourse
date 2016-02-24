class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.string :name, null: false, index: true
      t.string :description

      t.timestamps null: false
    end
  end
end
