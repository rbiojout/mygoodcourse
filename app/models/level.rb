class Level < ActiveRecord::Base
  belongs_to :cycle

  has_and_belongs_to_many :products

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

  # cycles with products
  scope :with_products_for_cycle, -> (cycle_id) { Level.joins(:products).where(:cycle_id => cycle_id).distinct }


end
