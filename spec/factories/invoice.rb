FactoryGirl.define do
  factory(:invoice) do
    user
    total_in_cents 1000
    number 1234
    href 'http://test.example.com/1000'
    created_at { 1.day.ago }
    uuid SecureRandom.uuid
  end

end
