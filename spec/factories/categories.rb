FactoryGirl.define do
  factory :category, class: Category do
    name          { Faker::Lorem.sentence }
    family


    trait :with_active_products do
      transient do
        number_of_products 3
      end

      after(:build) do |category, evaluator|
        categories = []
        categories.push(category)
        create_list(:product, evaluator.number_of_products, :active, categories: categories)
      end
    end

    trait :with_not_active_products do
      transient do
        number_of_products 3
      end

      after(:build) do |category, evaluator|
        categories = []
        categories.push(category)
        create_list(:product, evaluator.number_of_products, :not_active, categories: categories)
      end
    end

    trait :with_products do
      with_active_products
      with_not_active_products
    end
  end

end
