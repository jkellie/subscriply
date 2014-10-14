FactoryGirl.define do
  factory(:product) do
    organization
    name { Faker::Company.name }
  end
end
