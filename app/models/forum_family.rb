# == Schema Information
#
# Table name: forum_families
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  visual      :string
#  country_id  :integer
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_forum_families_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_ab56b7df45  (country_id => countries.id)
#

class ForumFamily < ActiveRecord::Base
  belongs_to :country

  has_many :forum_categories, dependent: :destroy

  has_many :forum_subjects, through: :forum_categories

  has_many :forum_answers, through: :forum_subjects

  acts_as_list scope: :country, add_new_at: :bottom

  validates :name, :country, presence: true

  mount_uploader :visual, VisualUploader
  validates :visual, presence: true

  default_scope -> { order(position: :asc) }

end
