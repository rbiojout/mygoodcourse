class Category < ActiveRecord::Base
  belongs_to :family

  has_and_belongs_to_many :products

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

end
