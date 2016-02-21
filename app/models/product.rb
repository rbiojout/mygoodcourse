class Product < ActiveRecord::Base
  has_many :attachments
  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates_presence_of :attachments


  #:reject_if => proc {|attributes| attributes['file'].blank?  && attributes['file_cache'].blank?}


  belongs_to :customer

  # validators
  validates :customer_id, :name, :description, :short_description, presence: true

  #default_scope -> { order(created_at: :desc) }




end
