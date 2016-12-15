FactoryGirl.define do
  factory :forum_category do
    name        { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    forum_family
  end
end
