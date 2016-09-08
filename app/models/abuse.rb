class Abuse < ActiveRecord::Base
  # polymorphic association
  belongs_to :abusable, polymorphic: true

  # customer that report the abuse
  belongs_to :customer

  validates :description, presence: true

end