module Billing

  def self.with_lock(organization, &block)
    Mutex.new.synchronize do
      Recurly.subdomain = organization.recurly_subdomain
      Recurly.api_key = organization.recurly_private_key

      block.call
    end
  end

  module User

    def self.create(user)
      Billing.with_lock(user.organization) do
        Recurly::Account.create(
          account_code: user.uuid,
          email:        user.email,
          first_name:   user.first_name,
          last_name:    user.last_name
        )
      end
    end

    def self.update_billing_info(user)
      billing_info = billing_info(user)
      
      user.update_attributes(
        card_type: billing_info.card_type,
        last_four: billing_info.last_four, 
        expiration: "#{billing_info.month} / #{billing_info.year}"
      )
    end

    def self.billing_info(user)
      account_on_billing(user).billing_info
    end

    def self.account_on_billing(user)
      Billing.with_lock(user.organization) do
        Recurly::Account.find(user.uuid)
      end
    end
  end

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

  module Plan

    def self.create(plan)
      Billing.with_lock(plan.organization) do
        Recurly::Plan.create(
          plan_code: plan.permalink,
          name: plan.name,
          description: plan.description,
          unit_amount_in_cents: plan.amount_in_cents,
          plan_interval_length: plan.charge_every,
          trial_interval_length: plan.free_trial_length,
          trial_interval_unit: 'days'
        )
      end
    end

    def self.update(plan)
      Billing.with_lock(plan.organization) do
        _plan = Recurly::Plan.find(plan.permalink)
        _plan.name = plan.name
        _plan.description = plan.description
        _plan.unit_amount_in_cents = plan.amount_in_cents
        _plan.plan_interval_length = plan.charge_every
        _plan.trial_interval_length = plan.free_trial_length
        _plan.save
      end
    end
  end

end