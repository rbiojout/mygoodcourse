# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  customer_id   :integer
#  likeable_id   :integer
#  likeable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_likes_on_customer_id                    (customer_id)
#  index_likes_on_likeable_type_and_likeable_id  (likeable_type,likeable_id)
#
# Foreign Keys
#
#  fk_rails_0e10a6e531  (customer_id => customers.id)
#

class Like < ApplicationRecord
  belongs_to :customer
  belongs_to :likeable, polymorphic: true

  scope :for_customer_likeable, ->(customer, likeable) { where(customer: customer).where(likeable: likeable).distinct }
end
