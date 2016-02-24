class Family < ActiveRecord::Base

  has_many :categories
  accepts_nested_attributes_for :categories, reject_if: :all_blank, allow_destroy: true, allow_destroy: true



  validates :name, presence: true

end
