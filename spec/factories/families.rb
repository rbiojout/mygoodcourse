FactoryGirl.define do
  factory :family, class: Family do
    name          { Faker::Lorem.sentence }
    country
  end
end