FactoryGirl.define do
  factory :product, class: Product do
    name        { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    customer
    levels      { create_list(:level, 1) }
    categories { create_list(:category, 1) }
    after(:build) do |product, eval|
      product.attachments << FactoryGirl.build(:attachment, product: product)
    end
  end
end