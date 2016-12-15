FactoryGirl.define do
  factory :forum_answer do
    text { Faker::Lorem.sentence }
    forum_subject
  end
end
