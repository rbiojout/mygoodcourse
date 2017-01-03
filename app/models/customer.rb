# == Schema Information
#
# Table name: customers
#
#  id                          :integer          not null, primary key
#  name                        :string
#  first_name                  :string
#  mobile                      :string
#  picture                     :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  email                       :string           default(""), not null
#  encrypted_password          :string           default(""), not null
#  reset_password_token        :string
#  reset_password_sent_at      :datetime
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0), not null
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :inet
#  last_sign_in_ip             :inet
#  formatted_address           :string
#  street_address              :string
#  administrative_area_level_1 :string
#  administrative_area_level_2 :string
#  postal_code                 :string
#  locality                    :string
#  lat                         :decimal(, )
#  lng                         :decimal(, )
#  birthdate                   :date
#  score_reviews               :decimal(, )
#  nb_reviews                  :integer
#  confirmation_token          :string
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  unconfirmed_email           :string
#  language                    :string
#  country_id                  :integer
#  description                 :string
#  slug                        :string
#  counter_cache               :integer          default(0)
#
# Indexes
#
#  index_customers_on_confirmation_token    (confirmation_token) UNIQUE
#  index_customers_on_country_id            (country_id)
#  index_customers_on_email                 (email) UNIQUE
#  index_customers_on_reset_password_token  (reset_password_token) UNIQUE
#  index_customers_on_slug                  (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_595506fbcf  (country_id => countries.id)
#

class Customer < ActiveRecord::Base
  extend FriendlyId

  # follow activities
  # we explicitely indicate the reference because of rails_admin issues
  include Impressionist::IsImpressionable
  is_impressionable counter_cache: true, column_name: :counter_cache, unique: :all

  EMAIL_REGEX = /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i
  PHONE_REGEX = /\A[+?\d\ \-x\(\)]{7,}\z/

  friendly_id :slug_candidates, use: :slugged

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      [:first_name, :name],
      [:first_name, :name, :administrative_area_level_2],
    ]
  end

  def language_enum
    # Do not select any value, or add any blank field. RailsAdmin will do it for you.
    langs = []
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
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # add a file for image
  mount_uploader :picture, PictureUploader

  html_fragment :description, :scrub => :prune  # scrubs `description` using the :prune scrubber

  # Validations
  # validate in addition to Devise
  validates :name, :first_name, presence: true
  validates :mobile, allow_blank: true, format: {with: PHONE_REGEX}
  # terms of service
  validates :terms_of_service, acceptance: true

  # producst links
  # owned products
  has_many :products, dependent: :destroy

  # free products associated to the customer
  # include active and non active
  # @return [Products]
  def free_products
    Product.joins(:customer).where(price: '0.0').where(customers: {id: id})
  end

  # paid products associated to the customer
  # include active and non active
  # @return [Products]
  def paid_products
    Product.joins(:customer).where.not(price: '0.0').where(customers: {id: id})
  end

  # wished products
  has_many :wish_lists, dependent: :destroy
  has_many :wish_products, through: :wish_lists, source: :product

  belongs_to :country

  def own_product(product)
    products.include?(product)
  end

  has_many :reviews, dependent: :destroy

  # We don't want to delete if some orders have been done
  has_many :orders, dependent: :restrict_with_exception

  # we have a social follower/following process
  has_many :active_peers, class_name: 'Peer', foreign_key: 'follower_id'
  has_many :passive_peers, class_name: 'Peer', foreign_key: 'followed_id'

  # we have a social follower/following process
  has_many :followeds, through: :active_peers,  source: :followed
  has_many :followers, through: :passive_peers, source: :follower

  # payment solution StripeAccount
  has_one :stripe_account, class_name: 'StripeAccount', dependent: :destroy

  has_one :stripe_customer, class_name: 'StripeCustomer', dependent: :destroy
  has_many :stripe_cards, through: :stripe_customer

  # we have some abuses that has been reported by this customer
  has_many :reported_abuses, class_name: 'Abuse', foreign_key: 'customer_id', inverse_of: :customer

  # we have some likes that has been reported by this customer
  has_many :reported_likes, class_name: 'Like', foreign_key: 'customer_id', inverse_of: :customer

  has_many :likes, dependent: :delete_all

  has_many :posts, dependent: :delete_all

  # full name helper
  def full_name
    first_name + ' ' + name
  end

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
    wish_lists.find_by(product: product).destroy if wishing?(product)
  end

  # Returns true if the current customer has the product in his wish list.
  def wishing?(product)
    wish_products.include?(product)
  end
end
