FactoryGirl.define do
  factory(:plan) do
    product
    organization
    plan_type 'digital'
    name { Faker::Company.name }
    code { name.first(3).downcase }
    amount BigDecimal.new('99.0')

    trait :local_pick_up do
      plan_type 'local_pick_up'
    end

    trait :shipped do
      plan_type 'shipped'
    end
  end
end
