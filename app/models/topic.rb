# == Schema Information
#
# Table name: topics
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  position    :integer
#  slug        :string
#  country_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_topics_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_296866c32c  (country_id => countries.id)
#

class Topic < ActiveRecord::Base
  extend FriendlyId

  # we use slugs for finding the topics
  friendly_id :name, use: :slugged


  # linked to country with a position in the list
  belongs_to :country
  validates :country, :presence => true
  acts_as_list scope: :country, add_new_at: :bottom


  # associated to artcicles
  has_many :articles, dependent: :destroy
  accepts_nested_attributes_for :articles, reject_if: :all_blank, allow_destroy: true


  validates :name, presence: true

  # we want a name with a Capital
  include CapitalizeName
  before_save :capitalize_name

  

  # ordered by the position by default
  default_scope -> { order(position: :asc) }

  # topics with articles
  scope :with_articles, -> { Topic.joins(:articles).distinct }



end
