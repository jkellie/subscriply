FactoryGirl.define do
  factory(:plan) do
    product
    organization
    plan_type 'digital'

    after(:build) do |p|
      p.stub(:create_on_recurly).and_return true
    end
  end

  
end
