class CreateCycles < ActiveRecord::Migration
  def change
    create_table :cycles do |t|
      t.string :name
      t.string :description
      t.integer :position

      t.timestamps null: false
    end
  end
end
