class Category < ActiveRecord::Base
  belongs_to :family

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

end
