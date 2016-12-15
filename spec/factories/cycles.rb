FactoryGirl.define do
  factory :cycle, class: Cycle do
    name          { Faker::Lorem.sentence }
    country

    trait :with_levels do
      transient do
        number_of_levels 3
      end

      after(:build) do |cycle, evaluator|
        create_list(:level, evaluator.number_of_levels, cycle: cycle)
      end
    end
  end
end
