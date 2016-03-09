class Product < ActiveRecord::Base
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, :reject_if => proc {|attributes| attributes['file'].blank?  && attributes['file_cache'].blank?},  allow_destroy: true
  #
  validates_presence_of :attachments, :message => "You need to provide at least one version of attachment. Please add a new version."
  before_update :ensure_attachment_present

  belongs_to :customer
  # validators
  validates :customer_id, :name, :description, :short_description, presence: true

  #default_scope -> { order(created_at: :desc) }


  # Ordered items which are associated with this product
  # We don't want to delete if some orders have been collected
  has_many :order_items, dependent: :restrict_with_exception
  before_destroy :ensure_not_referenced_by_any_order_item

  # Orders which have ordered this product
  has_many :orders, through: :order_items

  has_and_belongs_to_many :categories, table_name: 'products_categories'
  has_many :families, through: :categories


  # Before validation, set the permalink if we don't already have one
  before_validation { self.permalink = name.parameterize if permalink.blank? && name.is_a?(String) }

  # All active products
  scope :active, -> { where(active: true) }

  # All featured products
  scope :featured, -> { where(featured: true) }




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
