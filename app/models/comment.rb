# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  text             :text
#  customer_id      :integer
#  commentable_id   :integer
#  commentable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_customer_id                          (customer_id)
#
# Foreign Keys
#
#  fk_rails_1eff374fe1  (customer_id => customers.id)
#

class Comment < ActiveRecord::Base
  belongs_to :customer
  belongs_to :commentable, polymorphic: true

  # we have some abuses that can be reported by customers
  has_many :abuses, class_name: "Abuse", as: :abusable

  validates :text, presence: true
end
