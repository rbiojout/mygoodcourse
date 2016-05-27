class Level < ActiveRecord::Base
  belongs_to :cycle

  has_and_belongs_to_many :products

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

  # levels with products
  scope :with_products, -> { Level.joins(:products).distinct }

  # levels active with products
  scope :with_active_products, -> { Level.joins(:products).where(products: {active: true}).distinct }


  # levels with products
  scope :with_products_for_cycle, -> (cycle_id) { Level.joins(:products).where(:cycle_id => cycle_id).distinct }

  # restrict if Family(ies) and/or Category(ies) is selected
  # @family_id : list of families, default to "0"
  # @category_id : list of categories, default to "0"
  # @active : flag for only active, default to false
  def self.associated_to_families_categories(family_id, category_id, active)
    family_id ||= "0"
    category_id ||= "0"
    active ||=false
    # return all by default
    if family_id =="0"
      unless category_id == "0"
        # we filter at the Categories level
        if active
          Level.joins(products: :categories).where(categories: {id: category_id}).where(products: {active: true})
        else
          Level.joins(products: :categories).where(categories: {id: category_id})
        end
      # special case no filter
      else
        if active
          Level.with_active_products
        else
          Level.all
        end
      end
    else
      # we filter at the Families level
      if active
        Level.joins(products: [{ categories: :family }]).where(families: {id: family_id}).where(products: {active: true})
      else
        Level.joins(products: [{ categories: :family }]).where(families: {id: family_id})
      end
    end
  end

end
