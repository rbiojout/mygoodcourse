FactoryGirl.define do
  factory :level, class: Level do
    name          { Faker::Lorem.sentence }
    cycle

    trait :with_active_products do
      transient do
        number_of_products 3
      end

      after(:build) do |level, evaluator|
        levels = []
        levels.push(level)
        create_list(:product, evaluator.number_of_products, :active, levels: levels)
      end
    end

    trait :with_not_active_products do
      transient do
        number_of_products 3
      end

      after(:build) do |level, evaluator|
        levels = []
        levels.push(level)
        create_list(:product, evaluator.number_of_products, :not_active, levels: levels)
      end
    end

    trait :with_products do
      with_active_products
      with_not_active_products
    end
  end
end
