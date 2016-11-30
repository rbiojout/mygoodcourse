FactoryGirl.define do
  factory :review, class: Review do
    title         { Faker::Lorem.sentence }
    description   { Faker::Lorem.sentence }
    score         { Faker::Number.between(0, 5) }
    product
  end
end
