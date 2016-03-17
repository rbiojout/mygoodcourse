class Cycle < ActiveRecord::Base
  has_many :levels, dependent: :destroy, inverse_of: :cycle
  accepts_nested_attributes_for :levels, reject_if: :all_blank, allow_destroy: true

  has_many :products, through: :levels

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

  # cycles with products
  scope :with_products, -> { Cycle.joins(:products).distinct }

  # families with products
  scope :with_products_for_cycle, -> (cycle_id) { Category.joins(:products).where(:family_id => family_id).distinct }



end
