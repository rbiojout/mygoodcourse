FactoryGirl.define do
  factory :post do
    name          { Faker::Lorem.sentence }
    description   { Faker::Lorem.characters(500) }
    customer
    visual File.open(File.join(Rails.root, '/public/uploads/test/post/visual/default_visual.jpg'))
  end
end
