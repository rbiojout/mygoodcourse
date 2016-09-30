class ChangeNbCommentsInProduct < ActiveRecord::Migration
  def self.up
    change_column_default :products, :nb_comments, 0
    change_column_default :products, :score_comments, 0
    Product.where("nb_comments is NUll").update_all(:nb_comments => 0)
    Product.where("score_comments is NUll").update_all(:score_comments => 0)
  end

  def self.down
    change_column_default :products, :nb_comments, nil
    change_column_default :products, :score_comments, nil
    Product.where("nb_comments = 0").update_all(:nb_comments => nil)
    Product.where("score_comments = 0").update_all(:score_comments => nil)
  end

end
