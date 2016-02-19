class AddAddressToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :formatted_address, :string
    add_column :customers, :street_address, :string
    add_column :customers, :administrative_area_level_1, :string
    add_column :customers, :administrative_area_level_2, :string
    add_column :customers, :postal_code, :string
    add_column :customers, :locality, :string
    add_column :customers, :lat, :decimal
    add_column :customers, :lng, :decimal
  end
end
