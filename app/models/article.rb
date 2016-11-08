# == Schema Information
#
# Table name: articles
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  position      :integer
#  slug          :string
#  topic_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  counter_cache :integer          default(0)
#
# Indexes
#
#  index_articles_on_topic_id  (topic_id)
#
# Foreign Keys
#
#  fk_rails_ce7582c81f  (topic_id => topics.id)
#

class Article < ActiveRecord::Base
  extend FriendlyId

  # follow activities
  # we explicitely indicate the reference because of rails_admin issues
  include Impressionist::IsImpressionable
  is_impressionable :counter_cache => true, :column_name => :counter_cache, :unique => :all

  include PgSearch

  # we use slugs for finding the articles
  friendly_id :name, use: :slugged

  # associated to a topic and ordered in the list
  belongs_to :topic, :inverse_of => :articles
  validates :topic, :presence => true
  acts_as_list scope: :topic, add_new_at: :bottom

  # we want a name with a Capital
  include CapitalizeName
  before_save :capitalize_name

  validates :name, :description, presence: true


  # ordered by position by default
  default_scope -> { order(position: :asc) }

  # search options
  multisearchable :against => [:name, :description]
  pg_search_scope :search_by_text, :against => [:name, :description, ], :ignoring => :accents

  private



end
