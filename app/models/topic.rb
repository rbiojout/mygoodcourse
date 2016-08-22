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
  include CapitalizeNameConcern
  before_save :capitalize_name

  

  # ordered by the position by default
  default_scope -> { order(position: :asc) }

  # topics with articles
  scope :with_articles, -> { Topic.joins(:articles).distinct }



end
