FactoryGirl.define do
  factory(:plan) do
    product
    organization
    plan_type 'digital'
    name { Faker::Company.name }
    code { name.first(3).downcase }
    amount BigDecimal.new('99.0')
  end
end
