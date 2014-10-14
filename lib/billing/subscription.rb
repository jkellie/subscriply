module Billing
  
  module Subscription
    def self.create(subscription, token)
      Billing.with_lock(subscription.organization) do
        Recurly::Subscription.create!(
          plan_code: subscription.plan.permalink,
          account: { account_code: subscription.user.uuid, billing_info: { token_id: token } }
        )
      end
    end
  end

end