FactoryGirl.define do
  factory(:subscription) do
    organization
    user
    plan
    location
    uuid { SecureRandom.uuid }

    trait :active do
      state 'active'
    end

    trait :canceling do
      state 'canceling'
    end

    trait :canceled do
      state 'canceled'
    end
  end

end
