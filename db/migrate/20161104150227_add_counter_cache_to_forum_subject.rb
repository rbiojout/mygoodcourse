class AddCounterCacheToForumSubject < ActiveRecord::Migration
  def change
    add_column :forum_subjects, :counter_cache, :integer, default: 0
  end
end
