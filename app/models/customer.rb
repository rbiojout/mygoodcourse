class Customer < ActiveRecord::Base
  extend FriendlyId

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


  has_many :products, dependent: :destroy
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

  # Follows a user_mailer.
  def follow(other_customer)
    active_peers.create(followed: other_customer)
  end
  # Unfollows a user_mailer.
  def unfollow(other_customer)
    active_peers.find_by(followed: other_customer).destroy
  end
  # Returns true if the current user_mailer is following the other user_mailer.
  def following?(other_customer)
    followeds.include?(other_customer)
  end




end
