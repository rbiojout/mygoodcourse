FactoryGirl.define do
  factory :abuse_comment, class: Abuse do
    description { Faker::Lorem.sentence }
    customer
    association :abusable, factory: :comment
  end

  factory :abuse_customer, class: Abuse do
    description { Faker::Lorem.sentence }
    customer
    association :abusable, factory: :customer
  end

  factory :abuse_product, class: Abuse do
    description { Faker::Lorem.sentence }
    customer
    association :abusable, factory: :product
  end

  factory :abuse_review, class: Abuse do
    description { Faker::Lorem.sentence }
    customer
    association :abusable, factory: :review
  end
end
