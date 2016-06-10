class Cycle < ActiveRecord::Base
  has_many :levels, dependent: :destroy, inverse_of: :cycle
  accepts_nested_attributes_for :levels, reject_if: :all_blank, allow_destroy: true

  has_many :products, through: :levels

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

  # cycles with products
  scope :with_products, -> { Cycle.joins(:products).distinct }

  # cycles active with products
  scope :with_active_products, -> { Cycle.joins(:products).where(products: {active: true}).distinct }


  # families with products
  scope :with_products_for_cycle, -> (cycle_id) { Category.joins(:products).where(:family_id => family_id).distinct }

  # we look for the objects associated in case of a query
  def self.associated_to_products(query)
    if query.blank?
      Cycle.all
    else
      joins(:products).where(products: {id: Product.search_by_text(query)}).distinct
    end
  end

  # restrict if Family(ies) and/or Category(ies) is selected
  # @family_id : list of families, default to "0"
  # @category_id : list of categories, default to "0"
  # @active : flag for only active, default to false
  def self.associated_to_families_categories(family_id, category_id, query, active)
    family_id ||= "0"
    category_id ||= "0"
    active ||=false
    # return all by default
    if family_id =="0"
      unless category_id == "0"
        # we filter at the Categories level
        if active
          # check if query
          # we have no family, a CATEGORY, no query and ACTIVE
          if query.blank?
            Cycle.joins(products: :categories).where(categories: {id: category_id}).where(products: {active: true}).distinct
            # we have no family, a CATEGORY, a QUERY and ACTIVE
          else
            Cycle.joins(products: :categories).where(categories: {id: category_id}).where(products: {id: Product.search_by_text(query)}).where(products: {active: true}).distinct
          end

        else
          # we have no family, a CATEGORY, no query and no active
          if query.blank?
            Cycle.joins(products: :categories).where(categories: {id: category_id}).distinct
            # we have no family, a CATEGORY, a QUERY and no active
          else
            Cycle.joins(products: :categories).where(categories: {id: category_id}).where(products: {id: Product.search_by_text(query)}).distinct
          end
        end
        # special case no filter
      else
        if active
          # we have no family, no category, no query and ACTIVE
          if query.blank?
            Cycle.with_active_products
            # we have no family, no category, a QUERY and ACTIVE
          else
            Cycle.joins(:products).where(products: {id: Product.search_by_text(query)}).where(products: {active: true}).distinct
          end

        else
          # we have no family, no category, no query and no active
          if query.blank?
            Cycle.all
            # we have no family, no category, a QUERY and no active
          else
            Cycle.joins(:products).where(products: {id: Product.search_by_text(query)}).distinct
          end
        end
      end
    else
      # we filter at the Families level
      if active
        # we have FAMILY, no category, no query and ACTIVE
        if query.blank?
          Cycle.joins(products: [{ categories: :family }]).where(families: {id: family_id}).where(products: {active: true}).distinct
          # we have FAMILY, no category, a QUERY and ACTIVE
        else
          Cycle.joins(products: [{ categories: :family }]).where(families: {id: family_id}).where(products: {id: Product.search_by_text(query)}).where(products: {active: true}).distinct
        end
      else
        # we have FAMILY, no category, no query and no active
        if query.blank?
          Cycle.joins(products: [{ categories: :family }]).where(families: {id: family_id}).distinct
          # we have FAMILY, no category, a QUERY and no active
        else
          Cycle.joins(products: [{ categories: :family }]).where(families: {id: family_id}).where(products: {id: Product.search_by_text(query)}).distinct
        end
      end
    end
  end

end
