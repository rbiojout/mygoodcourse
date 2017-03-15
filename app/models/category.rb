# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  family_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#
# Indexes
#
#  index_categories_on_family_id  (family_id)
#  index_categories_on_name       (name)
#
# Foreign Keys
#
#  fk_rails_22ababf336  (family_id => families.id)
#

class Category < ApplicationRecord
  belongs_to :family, inverse_of: :categories
  acts_as_list scope: :family, add_new_at: :bottom

  has_and_belongs_to_many :products

  # html_fragment :description, :scrub => :prune  # scrubs `description` using the :prune scrubber
  html_fragment :description, :scrub => VideoScrubber.new  # scrubs `description` using our Video scrubber

  validates :name, presence: true

  # categories associated to products
  # Category.joins(:products).where(products: {:id => products})

  default_scope -> { order(position: :asc) }

  # families with products
  scope :with_products_for_family, ->(family_id) { Category.joins(:products).where(family_id: family_id).distinct }

  # with  products
  scope :with_products, -> { Category.joins(:products).distinct }

  # with active products
  scope :with_active_products, -> { Category.joins(:products).where(products: {active: true}).distinct }

  # we look for the objects associated in case of a query
  def self.associated_to_query(query)
    if query.blank?
      Category.all
    else
      joins(:products).where(products: {id: Product.search_by_text(query)}).distinct
    end
  end

  # restrict if Cycle(s) and/or Level(s) is selected
  # @cycle_id : list of cycles, default to "0"
  # @level_id : list of levels, default to "0"
  # @active : flag for only active, default to false
  def self.associated_to_cycles_levels(cycle_id, level_id, active)
    cycle_id ||= '0'
    level_id ||= '0'
    active ||= false
    # return all by default
    if cycle_id == '0'
      if level_id == '0'
        if active
          Category.with_active_products
        else
          Category.all
        end
      else
        # we filter at the Levels level
        if active
          Category.joins(products: :levels).where(levels: {id: level_id}).where(products: {active: true}).distinct
        else
          Category.joins(products: :levels).where(levels: {id: level_id}).distinct
        end
        # special case no filter
      end
    else
      # we filter at the Cycles level
      if active
        Category.joins(products: [{levels: :cycle}]).where(cycles: {id: cycle_id}).where(products: {active: true}).distinct
      else
        Category.joins(products: [{levels: :cycle}]).where(cycles: {id: cycle_id}).distinct
      end
    end
  end
end
