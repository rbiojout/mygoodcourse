class Cycle < ActiveRecord::Base
  has_many :levels, dependent: :destroy, inverse_of: :cycle
  accepts_nested_attributes_for :levels, reject_if: :all_blank, allow_destroy: true


  validates :name, presence: true


end
