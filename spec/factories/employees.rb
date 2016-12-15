FactoryGirl.define do
  factory :employee do
    email         { Faker::Internet.email }
    password      { Faker::Internet.password(8) }
  end
end
