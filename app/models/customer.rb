class Customer < ActiveRecord::Base
  extend FriendlyId

  # follow activities
  # we explicitely indicate the reference because of rails_admin issues
  include Impressionist::IsImpressionable
  is_impressionable :counter_cache => true, :column_name => :counter_cache, :unique => :all

  EMAIL_REGEX = /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i
  PHONE_REGEX = /\A[+?\d\ \-x\(\)]{7,}\z/

  friendly_id :slug_candidates, use: :slugged

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
        [:first_name, :name],
        [:first_name, :name, :administrative_area_level_2]
    ]
  end

  def language_enum
    # Do not select any value, or add any blank field. RailsAdmin will do it for you.
    langs = Array.new
    LANGUAGES.each do |lang|
      langs.push(lang.at(1))
    end
    # ['green', 'white']
    # alternatively
    # { green: 0, white: 1 }
    # [ %w(Green 0), %w(White 1)]
  end

  # Include default user_mailer modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # add a file for image
  mount_uploader :picture, PictureUploader


  # Validations
  # validate in addition to Devise
  validates :name, :first_name, :mobile, presence: true
  validates :mobile,   format: { with: PHONE_REGEX }

  # producst links
  # owned products
  has_many :products, dependent: :destroy


  # wished products
  has_many :wish_lists, dependent: :destroy
  has_many :wish_products, through: :wish_lists, source: :product

  belongs_to :country

  def own_product(product)
    self.products.include?(product)
  end

  has_many :comments, dependent: :destroy

  # We don't want to delete if some orders have been done
  has_many :orders, dependent: :restrict_with_exception

  # we have a social follower/following process
  has_many :active_peers, class_name:  "Peer", foreign_key: "follower_id"
  has_many :passive_peers, class_name:  "Peer", foreign_key: "followed_id"

  # we have a social follower/following process
  has_many :followeds, through: :active_peers,  source: :followed
  has_many :followers, through: :passive_peers, source: :follower

  # payment solution StripeAccount
  has_one :stripe_account, dependent: :destroy


  # we have some abuses that has been reported by this customer
  has_many :reported_abuses, class_name: "Abuse", foreign_key: "customer_id", inverse_of: :customer

  # Follows a customer.
  def follow(other_customer)
    active_peers.create(followed: other_customer)
  end
  # Unfollows a customer.
  def unfollow(other_customer)
    active_peers.find_by(followed: other_customer).destroy
  end
  # Returns true if the current customer is following the other customer.
  def following?(other_customer)
    followeds.include?(other_customer)
  end


  # Wishs a product.
  def wish(product)
    wish_lists.create(product: product) unless wishing?(product)
  end
  # Unwishs a product.
  def unwish(product)
    logger.debug("@@@@@ #{product} #{wish_lists.find_by(product: product)}")
    wish_lists.find_by(product: product).destroy if wishing?(product)
  end
  # Returns true if the current customer has the product in his wish list.
  def wishing?(product)
    wish_products.include?(product)
  end




end
