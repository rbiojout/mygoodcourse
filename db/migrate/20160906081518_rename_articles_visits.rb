class RenameArticlesVisits < ActiveRecord::Migration
  def change
    remove_column :articles, :visits
    add_column :articles, :counter_cache, :integer, :default => 0
  end
end
