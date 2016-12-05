FactoryGirl.define do
  factory :order_item do
    customer
    product
  end
end
