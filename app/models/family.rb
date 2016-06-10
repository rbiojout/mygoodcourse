class Family < ActiveRecord::Base

  has_many :categories, dependent: :destroy
  accepts_nested_attributes_for :categories, reject_if: :all_blank, allow_destroy: true

  has_many :products, through: :categories

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

  # families with products
  scope :with_products, -> { Family.joins(:products).distinct }

  # with active products
  scope :with_active_products, -> { Family.joins(:products).where(products: {active: true}).distinct }


  # we look for the objects associated in case of a query
  def self.associated_to_products(query)
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
  def self.associated_to_cycles_levels(cycle_id, level_id, query, active)
    cycle_id ||= "0"
    level_id ||= "0"
    active ||=false
    # return all by default
    if cycle_id =="0"
      unless level_id == "0"
        # we filter at the Levels level
        if active
          # check if query
          # we have no cycle, a LEVEL, no query and ACTIVE
          if query.blank?
            Family.joins(products: :levels).where(levels: {id: level_id}).where(products: {active: true}).distinct
            # we have no cycle, a LEVEL, a QUERY and ACTIVE
          else
            Family.joins(products: :levels).where(levels: {id: level_id}).where(products: {id: Product.search_by_text(query)}).where(products: {active: true}).distinct
          end
          #
        else
          # we have no cycle, a LEVEL, no query and not active
          if query.blank?
            Family.joins(products: :levels).where(levels: {id: level_id}).distinct
            # we have no cycle, a LEVEL, a QUERY and not active
          else
            Category.joins(products: :levels).where(levels: {id: level_id}).where(products: {id: Product.search_by_text(query)}).distinct
          end
        end
        # special case no filter for level
      else
        if active
          # check if query
          # we have no cycle, no level, no query and ACTIVE
          if query.blank?
            Family.with_active_products
            # we have no cycle, no level, a QUERY and ACTIVE
          else
            Family.joins(:products).where(products: {id: Product.search_by_text(query)}).where(products: {active: true}).distinct
          end
        else
          # check if query
          # we have no cycle, no level, no query and no active
          if query.blank?
            Family.all
            # we have no cycle, no level, a QUERY and no active
          else
            Family.joins(:products).where(products: {id: Product.search_by_text(query)}).distinct
          end
        end
      end
    else
      # we filter at the Cycles level
      if active
        # check if query
        # we have CYCLE, no level, no query and ACTIVE
        if query.blank?
          Family.joins(products: [{ levels: :cycle }]).where(cycles: {id: cycle_id}).where(products: {active: true}).distinct
          # we have CYCLE, no level, a QUERY and ACTIVE
        else
          Family.joins(products: [{ levels: :cycle }]).where(cycles: {id: cycle_id}).where(products: {id: Product.search_by_text(query)}).where(products: {active: true}).distinct
        end
      else
        # check if query
        # we have CYCLE, no level, no query and no active
        if query.blank?
          Family.joins(products: [{ levels: :cycle }]).where(cycles: {id: cycle_id}).distinct
          # we have CYCLE, no level, a QUERY and no active
        else
          Family.joins(products: [{ levels: :cycle }]).where(cycles: {id: cycle_id}).where(products: {id: Product.search_by_text(query)}).distinct
        end
      end
    end
  end

end
