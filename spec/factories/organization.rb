FactoryGirl.define do
  factory(:organization) do
    name { Faker::Company.name }
    subdomain { Faker::Internet.domain_word + rand(100).to_s }
  end
end
