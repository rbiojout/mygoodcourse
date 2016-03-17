class AddPositionToFamiliesAndCycles < ActiveRecord::Migration
  def change
    add_column :families, :position, :integer
  end
end
