module Billing::Subscription

  def self.subscription_module
    Recurly::Subscription
  end

  def self.create(subscription)
    Billing.with_lock(subscription.organization) do
      billing_subscription = subscription_module.create!(
        plan_code: subscription.plan.permalink, 
        account: { account_code: subscription.user.uuid }
      )
      subscription.update_attributes({
        uuid: billing_subscription.uuid,
        state: billing_subscription.state,
        next_bill_on: billing_subscription.current_period_ends_at,
        start_date: billing_subscription.activated_at
      })
    end
  end

  def self.create_with_token(subscription, token)
    Billing.with_lock(subscription.organization) do
      subscription_module.create!(
        plan_code: subscription.plan.permalink,
        account: { account_code: subscription.user.uuid, billing_info: { token_id: token } }
      )
    end
  end

  def self.update(subscription, new_attrs)
    Billing.with_lock(subscription.organization) do
      billing_subscription = subscription_on_billing(subscription)
      billing_subscription.update_attributes(new_attrs)
      subscription.update_attributes({
        state: billing_subscription.state,
        next_bill_on: billing_subscription.current_period_ends_at,
      })
    end
  end

  def self.subscription_on_billing(subscription)
    Billing.with_lock(subscription.organization) do
      subscription_module.find(subscription.uuid.gsub('-', '')) #Bug with Recurly's API that does not like dashes in uuid's. Only affects subscriptions.
    end
  end

end