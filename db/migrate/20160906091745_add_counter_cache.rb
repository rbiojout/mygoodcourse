class AddCounterCache < ActiveRecord::Migration
  def change
    add_column :products, :counter_cache, :integer, :default => 0
    add_column :customers, :counter_cache, :integer, :default => 0
  end
end
