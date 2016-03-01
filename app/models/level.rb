class Level < ActiveRecord::Base
  belongs_to :cycle

  validates :name, presence: true

  default_scope -> { order(position: :asc) }

end
