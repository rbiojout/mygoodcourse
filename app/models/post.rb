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
#  status        :string
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


  # State Machine
  include AASM

  aasm :column => 'status' do
    state :created, :initial => true
    state :received, :accepted, :rejected, :corrected

    event :receive do
      before do
        logger.debug('Preparing to receive')
      end
      transitions :from => :created, :to => :received
    end

    event :accept do
      transitions :from => :received, :to => :accepted
    end

    event :reject do
      transitions :from => :received, :to => :rejected
    end

    event :cancel do
      transitions :from => [:accepted, :rejected], :to => :received
    end
  end

  belongs_to :customer

  # we have some likes that can be reported by customers
  has_many :likes, class_name: "Like", as: :likeable

  # we have some comments that can be reported by customers
  has_many :comments, class_name: "Comment", as: :commentable


  mount_uploader :visual, VisualUploader
  attr_accessor :visual_width, :visual_height
  validates :visual, :description, :customer, presence: true
  #validate :check_dimensions, :on => [:create, :update]
  def check_dimensions
    #puts "------"
    #logger.debug("#{visual.width} - #{visual.height}")
    if !visual_cache.nil? && (visual.width < 1200 || visual.height < 600)
      errors.add :visual, "Dimension too small."
    end
  end

  def preview
    visual.nil? ? "http://fakeimg.pl/300x150/":visual.preview
  end

  def owned?(current_customer)
    if (current_customer.nil?)
      false
    else
      current_customer.id == customer_id
    end
  end

  def liked?(customer)
    Like.where(:likeable_id => self.id).where(:likeable_type => 'Post').where(:customer => customer).count > 0
  end


  validates :name, :description, :customer, presence: true
  validates :description, length: { minimum: 500 }
end
