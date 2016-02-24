class Product < ActiveRecord::Base
  has_many :attachments
  accepts_nested_attributes_for :attachments, allow_destroy: true

  #, :reject_if => proc {|attributes| attributes['file'].blank?  && attributes['file_cache'].blank?}

  validates_presence_of :attachments, :message => "You need to provide at least one version of attachment. Please add a new version."


  belongs_to :customer

  # validators
  validates :customer_id, :name, :description, :short_description, presence: true

  #default_scope -> { order(created_at: :desc) }


  def preview
    attachments.first.file.url(:preview)
  end


end
