class Family < ActiveRecord::Base

  has_many :categories, dependent: :destroy
  accepts_nested_attributes_for :categories, reject_if: :all_blank, allow_destroy: true

  has_many :products, through: :categories

  belongs_to :country
  validates :country, presence: true
  acts_as_list scope: :country, add_new_at: :bottom

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

  # families with products
  scope :with_products, -> { Family.joins(:products).distinct }

  # with active products
  scope :with_active_products, -> { Family.joins(:products).where(products: {active: true}).distinct }

  # families with products
  scope :with_products_for_cycle, -> (cycle_id) { Category.joins(:products).where(:cycle_id => cycle_id).distinct }

  # we look for the objects associated in case of a query
  def self.associated_to_query(query)
    if query.blank?
      Family.all
    else
      joins(:products).where(products: {id: Product.search_by_text(query)}).distinct
    end
  end

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
          Family.joins(products: :levels).where(levels: {id: level_id}).where(products: {active: true}).distinct
        else
          Family.joins(products: :levels).where(levels: {id: level_id}).distinct
        end
        # special case no filter
      else
        if active
          Family.with_active_products
        else
          Family.all
        end
      end
    else
      # we filter at the Cycles level
      if active
        joins(products: [{ levels: :cycle }]).where(cycles: {id: cycle_id}).where(products: {active: true}).distinct
      else
        joins(products: [{ levels: :cycle }]).where(cycles: {id: cycle_id}).distinct
      end
    end
  end

end
