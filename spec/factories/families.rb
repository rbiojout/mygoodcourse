FactoryGirl.define do
  factory :family, class: Family do
    name { Faker::Lorem.sentence }
    country

    trait :with_categories do
      transient do
        number_of_categories 3
      end

      after(:build) do |family, evaluator|
        create_list(:category, evaluator.number_of_categories, family: family)
      end
    end
  end
end
