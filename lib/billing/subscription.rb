module Billing::Subscription

  def self.subscription_module
    Recurly::Subscription
  end

  def self.create(subscription)
    Billing.with_lock(subscription.organization) do
      subscription_module.create!(
        plan_code: subscription.plan.permalink, 
        account: { account_code: subscription.user.uuid }
      )
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
      subscription_on_billing(subscription).update_attributes(new_attrs)
    end
  end

  def self.postpone(subscription, postpone_until)
    Billing.with_lock(subscription.organization) do
      subscription_on_billing(subscription).postpone(postpone_until)
    end
  end

  def self.cancel(subscription)
    Billing.with_lock(subscription.organization) do
      subscription_on_billing(subscription).cancel
    end
  end

  def self.terminate(subscription, refund_type)
    Billing.with_lock(subscription.organization) do
      subscription_on_billing(subscription).terminate(refund_type.to_sym)
    end
  end

  def self.subscription_on_billing(subscription)
    Billing.with_lock(subscription.organization) do
      subscription_module.find(subscription.uuid.gsub('-', '')) #Bug with Recurly's API that does not like dashes in uuid's. Only affects subscriptions.
    end
  end

end