class Product < ActiveRecord::Base
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, :reject_if => proc {|attributes| attributes['file'].blank?  && attributes['file_cache'].blank?},  allow_destroy: true
  #
  validates_presence_of :attachments, :message => "You need to provide at least one version of attachment. Please add a new version."
  before_update :ensure_attachment_present

  belongs_to :customer
  # validators
  validates :customer_id, :name, :description, presence: true

  #default_scope -> { order(created_at: :desc) }


  # Ordered items which are associated with this product
  # We don't want to delete if some orders have been collected
  has_many :order_items, dependent: :restrict_with_exception
  before_destroy :ensure_not_referenced_by_any_order_item

  # Orders which have ordered this product
  has_many :orders, through: :order_items

  # product is link to many categories
  has_and_belongs_to_many :categories, table_name: 'products_categories'
  has_many :families, through: :categories

  # product is linked to many levels
  has_and_belongs_to_many :levels, table_name: 'levels_products'
  has_many :cycles, through: :levels


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

  def self.find_by_category(category_id)
    has_category = false
    unless category_id.nil?
      if category_id.to_f > 0
        has_category = true
      end
    end
    logger.debug("===> #{category_id} #{category_id.to_f > 0} #{has_category} ")
    if has_category == true
      logger.debug("===> first ")
      joins(:categories).where(categories: {id: category_id})
    else
      logger.debug("===> second ")
      all
    end
  end

  def self.find_by_level(level_id)
    has_level = false
    unless level_id.nil?
      if level_id.to_f > 0
        has_level = true
      end
    end
    logger.debug("===>  #{level_id.to_f > 0}")
    logger.debug("===> #{level_id} #{level_id.to_f > 0} #{has_level} ")
    if(has_level)
      joins(:levels).where(levels: {id: level_id})
    else
      all
    end
  end


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
    logger.debug("===> #{category_id.to_f > 0}  #{level_id.to_f > 0}")
    if (has_category && has_level)
      joins(:categories).where(categories: {id: category_id}).joins(:levels).where(levels: {id: level_id})
    elsif(has_category)
      joins(:categories).where(categories: {id: category_id})
    elsif(has_level)
      joins(:levels).where(levels: {id: level_id})
    else
      all
    end
  end

  def preview
    # we return nil if nothing match
    nil
    unless attachments.first.nil?
      unless attachments.first.file.nil?
           attachments.first.file.url(:preview)
         end
    end
  end

  private
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_order_item
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
