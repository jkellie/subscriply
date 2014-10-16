module Billing::Subscription

  def self.subscription_module
    Recurly::Subscription
  end

  def self.create(subscription, token)
    Billing.with_lock(subscription.organization) do
      subscription_module.create!(
        plan_code: subscription.plan.permalink,
        account: { account_code: subscription.user.uuid, billing_info: { token_id: token } }
      )
    end
  end
  
end