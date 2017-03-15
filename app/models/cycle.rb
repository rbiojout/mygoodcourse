# == Schema Information
#
# Table name: cycles
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  country_id  :integer
#
# Indexes
#
#  index_cycles_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_74cd77e9b7  (country_id => countries.id)
#

class Cycle < ApplicationRecord

  # html_fragment :description, :scrub => :prune  # scrubs `description` using the :prune scrubber
  html_fragment :description, :scrub => VideoScrubber.new  # scrubs `description` using our Video scrubber

  has_many :levels, dependent: :destroy
  accepts_nested_attributes_for :levels, reject_if: :all_blank, allow_destroy: true

  has_many :products,  -> { distinct }, through: :levels

  belongs_to :country
  validates :country, presence: true
  acts_as_list scope: :country, add_new_at: :bottom

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

  # cycles with products
  scope :with_products, -> { Cycle.joins(:products).distinct }

  # cycles active with products
  scope :with_active_products, -> { Cycle.joins(:products).where(products: {active: true}).distinct }

  # families with products
  scope :with_products_for_family, ->(family_id) { Level.joins(:products).where(family_id: family_id).distinct }

  # we look for the objects associated in case of a query
  def self.associated_to_query(query)
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
  def self.associated_to_families_categories(family_id, category_id, active)
    family_id ||= '0'
    category_id ||= '0'
    active ||= false
    # return all by default
    if family_id == '0'
      if category_id == '0'
        if active
          Cycle.with_active_products
        else
          Cycle.all
        end
      else
        # we filter at the Categories level
        if active
          Cycle.joins(products: :categories).where(categories: {id: category_id}).where(products: {active: true}).distinct
        else
          Cycle.joins(products: :categories).where(categories: {id: category_id}).distinct
        end
        # special case no filter
      end
    else
      # we filter at the Families level
      if active
        Cycle.joins(products: [{categories: :family}]).where(families: {id: family_id}).where(products: {active: true}).distinct
      else
        Cycle.joins(products: [{categories: :family}]).where(families: {id: family_id}).distinct
      end
    end
  end
end
