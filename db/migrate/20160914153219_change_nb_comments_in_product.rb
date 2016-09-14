class ChangeNbCommentsInProduct < ActiveRecord::Migration
  def change
    change_column_default :products, :nb_comments, 0
    change_column_default :products, :score_comments, 0
    Product.where("nb_comments is NUll").update_all(:nb_comments => 0)
    Product.where("score_comments is NUll").update_all(:score_comments => 0)
  end
end
