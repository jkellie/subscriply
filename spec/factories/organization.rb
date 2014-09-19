FactoryGirl.define do
  factory(:organization) do
    name { Faker::Company.name }
    subdomain { Faker::Internet.domain_word }
  end
end
