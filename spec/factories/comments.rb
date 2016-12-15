FactoryGirl.define do
  factory :comment, class: Comment do
    text { Faker::Lorem.sentence }
  end
end
