class AddCountryToModels < ActiveRecord::Migration
  def change
    add_reference :customers, :country, index: true, foreign_key: true
    add_reference :families, :country, index: true, foreign_key: true
    add_reference :cycles, :country, index: true, foreign_key: true
  end
end
