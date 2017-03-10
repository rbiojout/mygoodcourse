class AddReviewsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :nb_comments, :integer
    add_column :products, :score_comments, :decimal
  end
end
