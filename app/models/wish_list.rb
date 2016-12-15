# == Schema Information
#
# Table name: wish_lists
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  product_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_wish_lists_on_customer_id  (customer_id)
#  index_wish_lists_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_158745247b  (product_id => products.id)
#  fk_rails_d23aa4df57  (customer_id => customers.id)
#

class WishList < ActiveRecord::Base
  belongs_to :customer, class_name: 'Customer', foreign_key: 'customer_id'
  belongs_to :product, class_name: 'Product', foreign_key: 'product_id'
end
