class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code2
      t.string :code3
      t.string :continent
      t.string :tld
      t.string :currency
      t.boolean :eu_member

      t.timestamps null: false
    end
  end
end
