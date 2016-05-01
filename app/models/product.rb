class Product < ActiveRecord::Base

  # we want a name with a Capital
  before_save :capitalize_name

  # we need at least one attachment
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, :reject_if => proc {|attributes| attributes['file'].blank?  && attributes['file_cache'].blank?},  allow_destroy: true
  validates_presence_of :attachments, :message => "You need to provide at least one version of attachment. Please add a new version."
  before_update :ensure_attachment_present

  # linked to customer as necessary
  belongs_to :customer
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
  validates_presence_of :categories, :message => "You need to provide at least one category."


  # product is linked to many levels
  has_and_belongs_to_many :levels, table_name: 'levels_products'
  has_many :cycles, through: :levels
  validates_presence_of :levels, :message => "You need to provide at least one level."


  # many comments linked, we consolidate the number and the average score
  has_many :comments, dependent: :destroy



  # Before validation, set the permalink if we don't already have one
  before_validation { self.permalink = name.parameterize if permalink.blank? && name.is_a?(String) }

  # All active products
  scope :active, -> { where(active: true) }

  # All featured products
  scope :featured, -> { where(featured: true) }

  # Can be an array of values
  scope :for_family, -> (family_id) {joins(:families).where(families: {id: family_id}).distinct}
  scope :for_category, -> (category_id) {joins(:categories).where(categories: {id: category_id}).distinct}

  # Can be an array of values
  scope :for_cycle, -> (cycle_id) {joins(:cycles).where(cycles: {id: cycle_id}).distinct}
  scope :for_level, -> (level_id) {joins(:levels).where(levels: {id: level_id}).distinct}

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
    joins(:orders).where(orders: {status: status}).distinct.order(created_at: 'desc')
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

  private
  # we want a name that start with capital
  def capitalize_name
    self.name = self.name.camelize
  end

  # ensure that there are no line items referencing this product
  def ensure_not_referenced
    if order_items.empty?
         return true
    else
         errors.add(:base, 'Line Order present')
         return false
    end
  end

  # ensure that there is at list one attachment
  def ensure_attachment_present
    if attachments.empty?
      return false
    else
      errors.add(:base, 'Attachment needed')
      return true
    end
  end

end
