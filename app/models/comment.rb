class Comment < ActiveRecord::Base
  belongs_to :product
  belongs_to :customer

  validates :title, :description, :score, :product, presence: true

  after_save :update_for_product
  after_update :update_for_product

  default_scope -> { order(updated_at: :desc) }

  # This search the comments already done for a particular product_id and customer_id
  # @param product_id [int] the id for the product
  # @param customer_id [int] the id for the customer
  # @return Comment
  scope :find_by_product_customer, -> (product_id, customer_id) {joins(:product).where(products: {:id => product_id, :customer_id => customer_id}).distinct}

  # This search all the comments already relatted to the products for a particular customer_id
  # @param customer_id [int] the id for the customer
  # @return Comment
  scope :find_for_all_product_of_customer, -> (customer_id) {joins(:product).where(products: {:customer_id => customer_id}).distinct  }

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
