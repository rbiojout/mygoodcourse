class RemoveShortDescriptionFromProduct < ActiveRecord::Migration
  def change
    remove_column :products, :short_description, :string
    add_column :customers, :description, :string
    #add_reference :customers, :type, polymorphic: true, index: true
  end
end
