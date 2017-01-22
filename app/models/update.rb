# == Schema Information
#
# Table name: updates
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  customer_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_updates_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_a19e00ae44  (customer_id => customers.id)
#

class Update < ApplicationRecord
  belongs_to :customer
end
