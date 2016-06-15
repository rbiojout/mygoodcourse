class Customer < ActiveRecord::Base

  EMAIL_REGEX = /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i
  PHONE_REGEX = /\A[+?\d\ \-x\(\)]{7,}\z/


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # add a file for image
  mount_uploader :picture, PictureUploader


  # Validations
  # validate in addition to Devise
  validates :name, :first_name, :mobile, presence: true
  validates :mobile,   format: { with: PHONE_REGEX }


  has_many :products, dependent: :destroy

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

  # Follows a user.
  def follow(other_customer)
    active_peers.create(followed: other_customer)
  end
  # Unfollows a user.
  def unfollow(other_customer)
    active_peers.find_by(followed: other_customer).destroy
  end
  # Returns true if the current user is following the other user.
  def following?(other_customer)
    followeds.include?(other_customer)
  end




end
