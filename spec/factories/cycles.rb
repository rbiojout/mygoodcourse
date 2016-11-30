FactoryGirl.define do
  factory :cycle, class: Cycle do
    name          { Faker::Lorem.sentence }
    country
  end
end