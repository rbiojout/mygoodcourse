class WishList < ActiveRecord::Base
  belongs_to :customer, class_name: "Customer", foreign_key: "customer_id"
  belongs_to :product, class_name: "Product", foreign_key: "product_id"

end
