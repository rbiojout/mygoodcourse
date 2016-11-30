FactoryGirl.define do
  factory :post do
    name          { Faker::Lorem.sentence }
    description   { Faker::Lorem.characters(500) }
    customer
    visual  File.open(File.join(Rails.root, '/spec/fixtures/files/default_visual.png'))
  end
end
