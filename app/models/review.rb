# == Schema Information
#
# Table name: reviews
#
#  id          :integer          not null, primary key
#  title       :string
#  description :string
#  score       :decimal(, )
#  product_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :integer
#
# Indexes
#
#  index_reviews_on_customer_id  (customer_id)
#  index_reviews_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_1eff374fe1  (customer_id => customers.id)
#  fk_rails_a0d280f6e4  (product_id => products.id)
#

class Review < ActiveRecord::Base
  belongs_to :product
  belongs_to :customer

  # we have some abuses that can be reported by customers
  has_many :abuses, class_name: 'Abuse', as: :abusable

  # we have some likes that can be reported by customers
  has_many :likes, class_name: 'Like', as: :likeable

  def liked?(customer)
    Like.where(likeable_id: id).where(likeable_type: 'Review').where(customer: customer).count.positive?
  end

  validates :title, :description, :score, :product, presence: true

  after_save :update_for_product
  after_update :update_for_product

  default_scope -> { order(updated_at: :desc) }

  # This search the reviews already done for a particular product_id and customer_id
  # @param product_id [int] the id for the product
  # @param customer_id [int] the id for the customer
  # @return Review
  scope :find_by_product_customer, ->(product_id, customer_id) { joins(:product).where(products: {id: product_id, customer_id: customer_id}).distinct }

  # This search all the reviews already relatted to the products for a particular customer_id
  # @param customer_id [int] the id for the customer
  # @return Review
  scope :find_for_all_product_of_customer, ->(customer_id) { joins(:product).where(products: {customer_id: customer_id}).distinct }

private

  def update_for_product
    reviews = product.reviews
    nb_reviews = reviews.size
    score_reviews = reviews.average(:score)
    product.nb_reviews = nb_reviews
    product.score_reviews = score_reviews
    product.save
  end
end
