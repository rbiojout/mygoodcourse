class Article < ActiveRecord::Base
  extend FriendlyId

  include PgSearch

  # we use slugs for finding the articles
  friendly_id :name, use: :slugged

  # associated to a topic and ordered in the list
  belongs_to :topic
  validates :topic, :presence => true
  acts_as_list scope: :topic, add_new_at: :bottom

  # we want a name with a Capital
  before_save :capitalize_name

  validates :name, :description, presence: true


  # ordered by position by default
  default_scope -> { order(position: :asc) }

  # search options
  multisearchable :against => [:name, :description]
  pg_search_scope :search_by_text, :against => [:name, :description, ], :ignoring => :accents

  private

  # we want a name that start with capital
  def capitalize_name
    self.name = self.name.capitalize
  end

end
