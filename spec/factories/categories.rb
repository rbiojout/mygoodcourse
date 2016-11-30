FactoryGirl.define do
  factory :category, class: Category do
    name          { Faker::Lorem.sentence }
    family
  end
end