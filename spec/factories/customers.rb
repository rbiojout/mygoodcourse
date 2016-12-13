FactoryGirl.define do
  factory :customer, class: Customer do
    name          { Faker::Name.last_name }
    first_name    { Faker::Name.first_name}
    email         { Faker::Internet.email }
    password      "Helloworld1*"
    password_confirmation      "Helloworld1*"
    mobile        { Faker::PhoneNumber.cell_phone }
    street_address       { Faker::Address.street_address }
    postal_code   { Faker::Address.postcode }
    locality      { Faker::Address.city }

  end
end