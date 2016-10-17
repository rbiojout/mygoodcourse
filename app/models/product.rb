# == Schema Information
#
# Table name: products
#
#  id             :integer          not null, primary key
#  name           :string
#  sku            :string
#  permalink      :string
#  description    :string
#  active         :boolean          default(TRUE)
#  price          :decimal(8, 2)    default(0.0)
#  featured       :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  customer_id    :integer
#  nb_comments    :integer          default(0)
#  score_comments :decimal(, )      default(0.0)
#  slug           :string
#  counter_cache  :integer          default(0)
#
# Indexes
#
#  index_products_on_customer_id  (customer_id)
#  index_products_on_slug         (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_252452a41b  (customer_id => customers.id)
#

class Product < ActiveRecord::Base
  extend FriendlyId
  include PgSearch

  # follow activities
  # we explicitely indicate the reference because of rails_admin issues
  include Impressionist::IsImpressionable
  is_impressionable :counter_cache => true, :column_name => :counter_cache, :unique => :all

  # contants values for Product
  # price list
  PRICE_LIST = ['0.0', '0.99', '4.99', '9.99', '14.99', '19.99']

  def price_enum
    # Do not select any value, or add any blank field. RailsAdmin will do it for you.
    PRICE_LIST
    # ['green', 'white']
    # alternatively
    # { green: 0, white: 1 }
    # [ %w(Green 0), %w(White 1)]
  end

  # pagination
  self.per_page = 12


  # we use slugs for finding the products
  friendly_id :name, use: :slugged

  # search options
  multisearchable :against => [:name, :description]
  pg_search_scope :search_by_text, :against => [:name, :description, ], :ignoring => :accents

  # we want a name with a Capital
  include CapitalizeNameConcern
  before_save :capitalize_name

  after_save :update_for_customer


  # we need at least one attachment
  has_many :attachments, -> { order(position: :asc) }, dependent: :destroy
  accepts_nested_attributes_for :attachments, :reject_if => proc {|attributes| attributes['file'].blank?  && attributes['file_cache'].blank?},  allow_destroy: true
  validates_presence_of :attachments
  before_update :ensure_attachment_present

  # linked to customer as necessary
  belongs_to :customer
  # or through wish_list
  # wished products
  has_many :wish_lists, dependent: :destroy
  has_many :wish_customers, through: :wish_lists, source: :customer

  # we have some abuses that can be reported by customers
  has_many :abuses, class_name: "Abuse", as: :abusable

  # we have some likes that can be reported by customers
  has_many :likes, class_name: "Like", as: :likeable

  def liked?(customer)
    Like.where(:likeable_id => self.id).where(:likeable_type => 'Product').where(:customer => customer).count > 0
  end


  # validators
  validates :customer_id, :name, :description, presence: true



  #default_scope -> { order(created_at: :desc) }


  # Ordered items which are associated with this product
  # We don't want to delete if some orders have been collected
  has_many :order_items, dependent: :restrict_with_exception

  #before_destroy :ensure_not_referenced
  #before_destroy validates :order_items, absence: true

  # Orders which have ordered this product
  has_many :orders, through: :order_items

  # product is link to many categories
  has_and_belongs_to_many :categories, table_name: 'categories_products'
  has_many :families, through: :categories
  validates_presence_of :categories


  # product is linked to many levels
  has_and_belongs_to_many :levels, table_name: 'levels_products'
  has_many :cycles, through: :levels
  validates_presence_of :levels


  # many comments linked, we consolidate the number and the average score
  has_many :comments, dependent: :destroy



  # Before validation, set the permalink if we don't already have one
  before_validation { self.permalink = name.parameterize if permalink.blank? && name.is_a?(String) }

  # All featured products
  scope :featured, -> { where(featured: true) }

  # only active
  scope :active, ->{ where(active: true)}

  # Can be an array of values
  scope :for_family, -> (family_id) {joins(:families).where(families: {id: family_id}).distinct}
  scope :for_category, -> (category_id) {joins(:categories).where(categories: {id: category_id}).distinct}

  # associated product for a given product
  # based on the categories and levels
  # sort by the score and updated date
  # limit to 4x3 to have a display OK in both sizes of devices inline with the grid system of 12
  def self.associated_products(products)
    categories = Category.joins(:products).where(products: {:id => products}).unscope(:order).distinct
    levels = Level.joins(:products).where(products: {:id => products}).unscope(:order).distinct
    #Product.joins(:categories).where(categories: {id: categories}).where.not(id: products)


    Product.joins(:categories).where(categories: {id: categories}).joins(:levels).where(levels: {id: levels}).distinct.order(score_comments: :desc).order(updated_at: :desc).where.not(id: products).limit(12)
  end

  # count the active products for a list of families
  def self.count_active_for_family(family_id)
    Product.joins(:families).where(families: {id: family_id}).where(active: true).distinct.count
  end

  # count the active products for a list of families filtered by the cycles and levels
  def self.count_active_filtered_for_family(family_id, cycle_id, level_id)
    # use low level if present
    unless level_id.nil?
      Product.joins(:families).joins(levels: :cycle).where(families: {id: family_id}).where(levels: {id: level_id}).where(active: true).distinct.count unless level_id.to_s =="0"
      # use parent else
    else
      unless cycle_id.nil?
        Product.joins(:families).joins(levels: :cycle).where(families: {id: family_id}).where(cycles: {id: cycle_id}).where(active: true).distinct.count unless cycle_id.to_s =="0"
        # query all
      else
        Product.joins(:families).joins(levels: :cycle).where(families: {id: family_id}).distinct.count
      end
    end
  end

  # count the active products based on a list of categories
  def self.count_active_for_category(category_id)
    Product.joins(:categories).where(categories: {id: category_id}).where(active: true).distinct.count
  end

  # count the number of active products based on a list of categories filtered by cycles and levels
  def self.count_active_filtered_for_category(category_id, cycle_id, level_id)
    # use low level if present
    unless level_id.nil?
      Product.joins(:families).joins(levels: :cycle).where(categories: {id: category_id}).where(levels: {id: level_id}).where(active: true).distinct.count unless level_id.to_s =="0"
      # use parent else
    else
      unless cycle_id.nil?
        Product.joins(:families).joins(levels: :cycle).where(categories: {id: category_id}).where(cycles: {id: cycle_id}).where(active: true).distinct.count unless cycle_id.to_s =="0"
        # query all
      else
        Product.joins(:families).joins(levels: :cycle).where(categories: {id: category_id}).distinct.count
      end
    end

  end

  # Can be an array of values
  scope :for_cycle, -> (cycle_id) {joins(:cycles).where(cycles: {id: cycle_id}).distinct}
  scope :for_level, -> (level_id) {joins(:levels).where(levels: {id: level_id}).distinct}

  def self.count_active_for_cycle(cycle_id)
    Product.joins(:cycles).where(cycles: {id: cycle_id}).where(active: true).distinct.count
  end

  def self.count_active_filtered_for_cycle(cycle_id, family_id, category_id)
    # use low level if present
    unless category_id.nil?
      Product.joins(:cycles).joins(categories: :family).where(cycles: {id: cycle_id}).where(categories: {id: category_id}).where(active: true).distinct.count unless category_id.to_s =="0"
    # use parent else
    else
      unless family_id.nil?
        Product.joins(:cycles).joins(categories: :family).where(cycles: {id: cycle_id}).where(families: {id: family_id}).where(active: true).distinct.count unless family_id.to_s =="0"
      # query all
      else
        Product.joins(:cycles).joins(categories: :family).where(cycles: {id: cycle_id}).where(active: true).distinct.count
      end
    end
  end

  def self.count_active_for_level(level_id)
    Product.joins(:levels).where(levels: {id: level_id}).distinct.count
  end

  def self.count_active_filtered_for_level(level_id, family_id, category_id)
    # use low level if present
    unless category_id.nil?
      Product.joins(:levels).joins(categories: :family).where(levels: {id: level_id}).where(categories: {id: category_id}).where(active: true).distinct.count unless category_id.to_s =="0"
      # use parent else
    else
      unless family_id.nil?
        Product.joins(:levels).joins(categories: :family).where(levels: {id: level_id}).where(families: {id: family_id}).where(active: true).distinct.count unless family_id.to_s =="0"
        # query all
      else
        Product.joins(:levels).joins(categories: :family).where(levels: {id: level_id}).where(active: true).distinct.count
      end
    end
  end

  # Return all product linked to a category
  # not filtering on active state
  # @param category_id [int] the id for the category
  # @return [Collection]
  def self.find_by_category(category_id)
    has_category = false
    unless category_id.nil?
      if category_id.to_f > 0
        has_category = true
      end
    end
    #logger.debug("===> #{category_id} #{category_id.to_f > 0} #{has_category} ")
    if has_category == true
      #logger.debug("===> first ")
      joins(:categories).where(categories: {id: category_id})
    else
      #logger.debug("===> second ")
      all
    end
  end

  # Return all product linked to a level
  # not filtering on active state
  # @param level_id [int] the id for the level
  # @return [Collection]
  def self.find_by_level(level_id)
    has_level = false
    unless level_id.nil?
      if level_id.to_f > 0
        has_level = true
      end
    end
    #logger.debug("===>  #{level_id.to_f > 0}")
    #logger.debug("===> #{level_id} #{level_id.to_f > 0} #{has_level} ")
    if has_level
      joins(:levels).where(levels: {id: level_id})
    else
      all
    end
  end


  # Return all product linked to a category and level
  # not filtering on active state
  # @param category_id [int] the id for the category
  # @param level_id [int] the id for the level
  # @return [Collection]
  def self.find_by_category_and_level(category_id, level_id)
    has_category = false
    has_level = false
    unless category_id.nil?
      if category_id.to_f > 0
        has_category = true
      end
    end
    unless level_id.nil?
      if level_id.to_f > 0
        has_level = true
      end
    end
    #logger.debug("===> #{category_id.to_f > 0}  #{level_id.to_f > 0}")
    if (has_category && has_level)
      joins(:categories).where(categories: {id: category_id}).joins(:levels).where(levels: {id: level_id})
    elsif has_category
      joins(:categories).where(categories: {id: category_id})
    elsif has_level
      joins(:levels).where(levels: {id: level_id})
    else
      all
    end
  end

  # Get all the products attached to a customers based on the orders
  # no filtering on active state
  # @param customer_id [int] the id for the customer
  # @param status [String] the status state, default 'accepted'
  # @return [Collection]
  def self.find_ordered_by_customer(customer_id, status = 'accepted')
    status = Order::STATUSES.include?(status) ? status : 'accepted'
    Product.joins(:orders).where(orders: {status: status, customer_id: customer_id}).distinct.order(created_at: 'desc')
    #Product.joins(:orders).where(orders: {status: status, customer_id: 4})
  end

  def self.find_bought_by_customer(customer_id)
    Product.joins(:orders).where(orders: {status: 'accepted', customer_id: customer_id}).distinct.order(created_at: 'desc')
  end

  def is_bought_by_customer(customer_id)
    #Product.joins(:orders).where(orders: {status: 'accepted', customer_id: customer_id}).distinct.order(created_at: 'desc')
    Product.joins(:orders).where(orders: {status: 'accepted', customer_id: customer_id}).joins(:order_items).where(order_items: {product_id: self.id}).count > 0
  end

  # return the URL of the file corresponding to the preview prepared
  # in case of problem, returns the defaut preview
  # @return [String]
  def attachment
    begin
      attachments.first
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      Attachment.new
    end
  end

  # return the URL of the file corresponding to the preview prepared
  # in case of problem, returns the defaut preview
  # @return [String]
  def preview
    begin
     attachments.first.file.url(:preview)
    rescue Exception => exc
      logger.error("Message for the log file while retrieving preview #{exc.message}")
      "empty_file.png"
    end
  end

  # return the URL of the file corresponding to the small preview prepared
  # in case of problem, returns the defaut preview
  # @return [String]
  def small
    begin
      attachments.first.file.url(:small)
    rescue Exception => exc
      logger.error("Message for the log file while retrieving small preview #{exc.message}")
      "empty_file.png"
    end
  end

  # return the URL of the file corresponding to the large preview prepared
  # in case of problem, returns the defaut preview
  # @return [String]
  def large
    begin
      attachments.first.file.url(:large)
    rescue Exception => exc
      logger.error("Message for the log file while retrieving large preview #{exc.message}")
      "empty_file.png"
    end
  end

  def file_url
    begin
      attachments.first.file.url()
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      "empty_file.pdf"
    end
  end


  def candownload(customer)
    false
    unless customer.nil?
      # if this is a product from the customer, it is ok
      if self.customer.id == customer.id
        true
      # CHANGED TO HAVE AN ORDER EVEN IF FREE
      # if the price is nil that's ok
      #elsif self.price.nil?
      #  true
      else
        # we need to find a valid order paid
        is_bought_by_customer(customer.id)
      end
    end
  end

  def cancomment(customer)
    false
    unless customer.nil?
      # owner can not put comment
      if (self.customer.id != customer.id)
        # we need to find a valid order paid
        if is_bought_by_customer(customer.id)
          # only one comment per user per product
          if Comment.find_by_product_customer(self.id, self.customer.id).count==0
            true
          end
        end
      end
    end
  end

  #####
  # common method to access quickly
  #####

  # return the nbpages of the file corresponding to the attachment
  # in case of problem, returns 0
  # @return [int]
  def nbpages
    begin
      attachments.order(position: 'asc').first.nbpages
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      0
    end
  end

  # return the filesize of the file corresponding to the attachment
  # in case of problem, returns 0
  # @return [int]
  def file_size
    begin
      # pretty value
      attachments.order(position: 'asc').first.file_size
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      0
    end
  end

  # return the filesize of the file corresponding to the attachment
  # in case of problem, returns 0
  # @return [String]
  def file_type
    begin
      attachments.order(position: 'asc').first.file_type
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      "application/pdf"
    end
  end

  private

  # ensure that there are no line items referencing this product
  def ensure_not_referenced
    if order_items.empty?
      true
    else
       errors.add(:base, 'Line Order present')
       false
    end
  end

  # ensure that there is at list one attachment
  def ensure_attachment_present
    if attachments.empty?
      false
    else
      errors.add(:base, 'Attachment needed')
      true
    end
  end

  # aggregate the score of comments for user_mailer
  def update_for_customer
    comments = Comment.find_for_all_product_of_customer(customer.id)
    nb_comments = comments.size
    score_comments = comments.average(:score)
    customer.nb_comments = nb_comments
    customer.score_comments = score_comments
    customer.save
  end

end
