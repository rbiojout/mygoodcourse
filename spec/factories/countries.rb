FactoryGirl.define do
  factory :country, class: Country do
    name          { Faker::Address.country }

    trait :with_cycles do
      transient do
        number_of_cycles 3
      end

      after(:build) do |country, evaluator|
        create_list(:cycle, evaluator.number_of_cycles, country: country)
      end
    end

    trait :with_cycles_and_levels do
      transient do
        number_of_cycles 3
      end

      after(:build) do |country, evaluator|
        create_list(:cycle, evaluator.number_of_cycles, :with_levels, country: country)
      end
    end

    trait :with_families do
      transient do
        number_of_families 3
      end

      after(:build) do |country, evaluator|
        create_list(:family, evaluator.number_of_families, country: country)
      end
    end

    trait :with_families_and_categories do
      transient do
        number_of_families 3
      end

      after(:build) do |country, evaluator|
        create_list(:family, evaluator.number_of_families, :with_categories, country: country)
      end
    end

    trait :with_topics do
      transient do
        number_of_topics 3
      end

      after(:build) do |country, evaluator|
        create_list(:topic, evaluator.number_of_topics, country: country)
      end
    end

    trait :with_topics_and_articles do
      transient do
        number_of_topics 3
      end

      after(:build) do |country, evaluator|
        create_list(:topic, evaluator.number_of_topics, :with_articles, country: country)
      end
    end

  end
end