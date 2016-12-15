FactoryGirl.define do
  factory :topic do
    name { Faker::Lorem.sentence }
    country

    trait :with_articles do
      transient do
        number_of_articles 3
      end

      after(:build) do |topic, evaluator|
        create_list(:article, evaluator.number_of_articles, topic: topic)
      end
    end
  end
end
