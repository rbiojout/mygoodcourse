FactoryGirl.define do
  factory :product, class: Product do
    name        { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    customer
    levels { create_list(:level, 1) }
    categories { create_list(:category, 1) }
    after(:build) do |product, _eval|
      product.attachments << FactoryGirl.build(:attachment, product: product)
    end

    trait :free do
      price 0.0
    end

    trait :paid do
      price Product::PRICE_LIST.sample
    end

    trait :ordered do
      order_items { create_list(:order_item, 1) }
    end

    trait :active do
      active true
    end

    trait :not_active do
      active false
    end
  end

  factory :product_active do
    association :product, :active
  end

  factory :product_not_active do
    association :product, :not_active
  end

  factory :product_free do
    association :product, :free
  end

  factory :product_paid do
    association :product, :paid
  end
end
