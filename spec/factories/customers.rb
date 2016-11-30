FactoryGirl.define do
  factory :customer, class: Customer do
    name          { Faker::Name.last_name }
    first_name    { Faker::FirstName.first_name}
    email         { Faker::Internet.email }
    password      { Faker::Internet.password(8)}
    mobile        { Faker::PhoneNumber.cell_phone }
    street_address       { Faker::Address.street_address }
    postal_code   { Faker::Address.postcode }
    locality      { Faker::Address.city }

  end
end