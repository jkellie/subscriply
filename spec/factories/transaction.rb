FactoryGirl.define do
  factory(:transaction) do
    user
    subscription
    invoice
    amount_in_cents 1000
    state 'success'
    transaction_type 'charge'
    created_at { 1.day.ago }
    uuid { SecureRandom.uuid }
  end
end
