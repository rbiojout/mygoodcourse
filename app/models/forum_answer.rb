# == Schema Information
#
# Table name: forum_answers
#
#  id               :integer          not null, primary key
#  text             :text
#  customer_id      :integer
#  forum_subject_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_forum_answers_on_customer_id       (customer_id)
#  index_forum_answers_on_forum_subject_id  (forum_subject_id)
#
# Foreign Keys
#
#  fk_rails_72f44e0cd9  (forum_subject_id => forum_subjects.id)
#  fk_rails_d6bfb1ed1a  (customer_id => customers.id)
#

class ForumAnswer < ActiveRecord::Base
  belongs_to :customer
  belongs_to :forum_subject

  # we have some comments that can be reported by customers
  has_many :comments, class_name: "Comment", as: :commentable

  validates :text, :forum_subject, presence: true

  default_scope -> { order(created_at: :desc) }
end
