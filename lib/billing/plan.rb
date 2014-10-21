module Billing::Plan

  def self.plan_module
    Recurly::Plan
  end

  def self.create(plan)
    Billing.with_lock(plan.organization) do
      plan_module.create(
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
      _plan = plan_on_billing(plan)
      _plan.update_attributes(
        name: plan.name,
        description: plan.description,
        unit_amount_in_cents: plan.amount_in_cents,
        plan_interval_length: plan.charge_every,
        trial_interval_length: plan.free_trial_length
      )
    end
  end

  def self.plan_on_billing(plan)
    Billing.with_lock(plan.organization) do
      plan_module.find(plan.permalink)
    end
  end
  
end
