FactoryGirl.define do
  factory :product, class: Product do
    name        { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    customer
    levels      { create_list(:level, 1) }
    categories { create_list(:category, 1) }
    after(:build) do |product, eval|
      product.attachments << FactoryGirl.build(:attachment, product: product)
    end

    factory :free_product do
      price 0.0
    end

    factory :paid_product do
      price Product::PRICE_LIST.sample
    end

    factory :ordered_product do
      order_items { create_list(:order_item, 1)}
    end

  end
end