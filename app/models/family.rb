class Family < ActiveRecord::Base

  has_many :categories, dependent: :destroy
  accepts_nested_attributes_for :categories, reject_if: :all_blank, allow_destroy: true

  has_many :products, through: :categories

  validates :name, presence: true

  # families with products
  scope :with_products, -> { Family.joins(:products).distinct }


end
