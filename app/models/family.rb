class Family < ActiveRecord::Base

  has_many :categories, dependent: :destroy
  accepts_nested_attributes_for :categories, reject_if: :all_blank, allow_destroy: true



  validates :name, presence: true

end
