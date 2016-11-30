FactoryGirl.define do
  factory :level, class: Level do
    name          { Faker::Lorem.sentence }
    cycle
  end
end