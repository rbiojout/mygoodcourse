FactoryGirl.define do
  factory :forum_subject do
    name        { Faker::Lorem.sentence}
    text        { Faker::Lorem.sentence}
    forum_category
  end
end
