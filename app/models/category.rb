class Category < ActiveRecord::Base
  belongs_to :family

  has_and_belongs_to_many :products

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

  # families with products
  scope :with_products_for_family, -> (family_id) { Category.joins(:products).where(:family_id => family_id).distinct }

  # with  products
  scope :with_products, -> { Category.joins(:products).distinct }

  # with active products
  scope :with_active_products, -> { Category.joins(:products).where(products: {active: true}).distinct }


  # restrict if Cycle(s) and/or Level(s) is selected
  # @cycle_id : list of cycles, default to "0"
  # @level_id : list of levels, default to "0"
  # @active : flag for only active, default to false
  def self.associated_to_cycles_levels(cycle_id, level_id, active)
    cycle_id ||= "0"
    level_id ||= "0"
    active ||=false
    # return all by default
    if cycle_id =="0"
      unless level_id == "0"
        # we filter at the Levels level
        if active
          Category.joins(products: :levels).where(levels: {id: level_id}).where(products: {active: true}).distinct
        else
          Category.joins(products: :levels).where(levels: {id: level_id}).distinct
        end
        # special case no filter
      else
        if active
          Category.with_active_products
        else
          Category.all
        end
      end
  else
      # we filter at the Cycles level
      if active
        Category.joins(products: [{ levels: :cycle }]).where(cycles: {id: cycle_id}).where(products: {active: true}).distinct
      else
        Category.joins(products: [{ levels: :cycle }]).where(cycles: {id: cycle_id}).distinct
      end
    end
  end

end
