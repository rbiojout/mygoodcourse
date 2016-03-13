class Category < ActiveRecord::Base
  belongs_to :family

  has_and_belongs_to_many :products

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

  # families with products
  scope :with_products_for_family, -> (family_id) { Category.joins(:products).where(:family_id => family_id).distinct }

end
