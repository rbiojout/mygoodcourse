FactoryGirl.define do
  factory :forum_family do
    name { Faker::Lorem.sentence }
    country
  end
end
