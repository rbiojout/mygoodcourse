class AddLanguageToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :language, :string
  end
end
