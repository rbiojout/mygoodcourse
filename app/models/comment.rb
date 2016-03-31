class Comment < ActiveRecord::Base
  belongs_to :product
  belongs_to :customer

  validates :title, :description, :score, :product, presence: true

  before_save :update_for_product
  before_update :update_for_product

  private

  def update_for_product
    comments = product.comments
    nb_comments = comments.size
    score_comments = comments.average(:score)
    product.nb_comments = nb_comments
    product.score_comments = score_comments
    product.save
  end


end
