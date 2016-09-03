class Product < ActiveRecord::Base
  extend FriendlyId
  include PgSearch

  # contants values for Product
  # price list
  PRICE_LIST = [nil, '0.99', '4.99', '9.99', '14.99', '19.99']
  # pagination
  self.per_page = 30


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


  def self.count_active_for_family(family_id)
    Product.joins(:families).where(families: {id: family_id}).where(active: true).distinct.count
  end

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

  def self.count_active_for_category(category_id)
    Product.joins(:categories).where(categories: {id: category_id}).where(active: true).distinct.count
  end

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
    joins(:orders).where(orders: {status: status, customer_id: customer_id}).distinct.order(created_at: 'desc')
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
      logger.error("Message for the log file #{exc.message}")
      "empty_preview.png"
    end
  end

  def file_url
    begin
      attachments.first.file.url()
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      "empty_preview.pdf"
    end
  end

  def candownload(customer)
    false
    unless customer.nil?
      # if the price is nil that's ok
      if self.price.nil?
        true
      elsif self.customer.id == customer.id
        # if this is a product from the customer, it is ok
        true
      else
        # we need to find a valid order paid
        OrderItem.find_OK_product_customer(customer.id, self, 'accepted').count > 0
      end
    end
  end

  def cancomment(customer)
    false
    unless customer.nil?
      # owner can not put comment
      if (self.customer.id != customer.id)
        # we need to find a valid order paid
        if OrderItem.find_OK_product_customer(customer.id, self, 'accepted').count > 0
          # only one comment per user per product
          if Comment.find_by_product_customer(self.id, self.customer.id).count==0
            true
          end
        end
      end
    end
  end


  # return the nbpages of the file corresponding to the attachment
  # in case of problem, returns 0
  # @return [String]
  def nbpages
    begin
      attachments.order(version_number: 'asc').first.nbpages
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      "empty_preview.png"
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
