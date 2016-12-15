FactoryGirl.define do
  factory :article, class: Article do
    name          { Faker::Lorem.sentence }
    description   { Faker::Lorem.sentence }
    topic
  end
end
