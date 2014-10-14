module Billing
  
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