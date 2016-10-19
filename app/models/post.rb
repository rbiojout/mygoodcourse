# == Schema Information
#
# Table name: posts
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  customer_id   :integer
#  counter_cache :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  slug          :string
#  visual        :string
#
# Indexes
#
#  index_posts_on_customer_id  (customer_id)
#  index_posts_on_slug         (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_294f894e6c  (customer_id => customers.id)
#

class Post < ActiveRecord::Base
  extend FriendlyId
  include PgSearch

  # follow activities
  # we explicitely indicate the reference because of rails_admin issues
  include Impressionist::IsImpressionable
  is_impressionable :counter_cache => true, :column_name => :counter_cache, :unique => :all

  # we use slugs for finding the products
  friendly_id :name, use: :slugged

  # search options
  multisearchable :against => [:name, :description]
  pg_search_scope :search_by_text, :against => [:name, :description, ], :ignoring => :accents

  # we want a name with a Capital
  include CapitalizeNameConcern
  before_save :capitalize_name

  belongs_to :customer

  # we have some likes that can be reported by customers
  has_many :likes, class_name: "Like", as: :likeable

  def liked?(customer)
    Like.where(:likeable_id => self.id).where(:likeable_type => 'Post').where(:customer => customer).count > 0
  end


  validates :name, :description, :customer, presence: true
  validates :description, length: { minimum: 500 }
end
