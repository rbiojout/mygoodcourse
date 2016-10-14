# == Schema Information
#
# Table name: levels
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  position    :integer
#  cycle_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_levels_on_cycle_id  (cycle_id)
#
# Foreign Keys
#
#  fk_rails_3d7ea94142  (cycle_id => cycles.id)
#

class Level < ActiveRecord::Base
  belongs_to :cycle, :inverse_of => :levels
  acts_as_list scope: :cycle, add_new_at: :bottom

  has_and_belongs_to_many :products

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

  # levels with products
  scope :with_products, -> { Level.joins(:products).distinct }

  # levels active with products
  scope :with_active_products, -> { Level.joins(:products).where(products: {active: true}).distinct }


  # levels with products
  scope :with_products_for_cycle, -> (cycle_id) { Level.joins(:products).where(:cycle_id => cycle_id).distinct }

  # we look for the objects associated in case of a query
  def self.associated_to_query(query)
    if query.blank?
      Level.all
    else
      joins(:products).where(products: {id: Product.search_by_text(query)}).distinct
    end
  end

  # restrict if Family(ies) and/or Category(ies) is selected
  # @family_id : list of families, default to "0"
  # @category_id : list of categories, default to "0"
  # @active : flag for only active, default to false
  def self.associated_to_families_categories(family_id, category_id, active)
    logger.debug(".... #{family_id}/#{category_id}/#{active}")
    family_id ||= "0"
    category_id ||= "0"
    active ||=false
    # return all by default
    if family_id =="0"
      unless category_id == "0"
        # we filter at the Categories level
        if active
          Level.joins(products: :categories).where(categories: {id: category_id}).where(products: {active: true}).distinct
        else
          Level.joins(products: :categories).where(categories: {id: category_id}).distinct
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
        Level.joins(products: [{ categories: :family }]).where(families: {id: family_id}).where(products: {active: true}).distinct
      else
        Level.joins(products: [{ categories: :family }]).where(families: {id: family_id}).distinct
      end
    end
  end


end
