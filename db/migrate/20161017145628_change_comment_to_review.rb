class ChangeCommentToReview < ActiveRecord::Migration

  def self.up
    remove_index :comments, :product_id
    remove_index :comments, :customer_id
    rename_table :comments, :reviews
    add_index :reviews, :product_id
    add_index :reviews, :customer_id
    rename_column :products, :nb_comments, :nb_reviews
    rename_column :products, :score_comments, :score_reviews
    rename_column :customers, :nb_comments, :nb_reviews
    rename_column :customers, :score_comments, :score_reviews
  end

  def self.down
    remove_index :reviews, :product_id
    remove_index :reviews, :customer_id
    rename_table :reviews, :comments
    add_index :comments, :product_id
    add_index :comments, :customer_id
    rename_column :products, :nb_reviews, :nb_comments
    rename_column :products, :score_reviews, :score_comments
    rename_column :customers, :nb_reviews, :nb_comments
    rename_column :customers, :score_reviews, :score_comments
  end
end
