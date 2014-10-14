FactoryGirl.define do
  factory(:location) do
    organization
    name { Faker::Address.city }
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip }
  end
end
