# == Schema Information
#
# Table name: forum_categories
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  visual          :string
#  forum_family_id :integer
#  position        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_forum_categories_on_forum_family_id  (forum_family_id)
#
# Foreign Keys
#
#  fk_rails_2c945ba926  (forum_family_id => forum_families.id)
#

class ForumCategory < ApplicationRecord
  belongs_to :forum_family

  has_many :forum_subjects, dependent: :destroy

  has_many :forum_answers, through: :forum_subjects

  acts_as_list scope: :forum_family, add_new_at: :bottom

  mount_uploader :visual, VisualUploader
  validates :visual, presence: true

  validates :name, :description, :forum_family, presence: true

  default_scope -> { order(position: :asc) }

  def count_subjects
    forum_subjects.count
  end

  def count_messages
    forum_subjects.count + forum_answers.count
  end

  def last_activity_date
    if forum_answers.count.positive?
      forum_answers.last.created_at
    elsif forum_subjects.count.positive?
      forum_subjects.last.created_at
    end
  end

  def last_activity_customer
    if forum_answers.count.positive?
      forum_answers.last.customer
    elsif forum_subjects.count.positive?
      forum_subjects.last.customer
    end
  end
end
