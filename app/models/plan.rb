class Plan < ActiveRecord::Base
  belongs_to :organization
  belongs_to :product

  after_create :create_on_recurly
  after_update :update_on_recurly

  def permalink
    "#{product.prepend_code}_#{self.code}"
  end

  def deletable?
    false
  end

  def trial?
    self.free_trial_length > 0
  end

  private

  def create_on_recurly
    Recurly.subdomain = organization.recurly_subdomain
    Recurly.api_key = organization.recurly_private_key
    Recurly::Plan.create(
      plan_code: self.permalink,
      name: self.name,
      description: self.description,
      unit_amount_in_cents: amount_in_cents,
      plan_interval_length: self.charge_every,
      trial_interval_length: self.free_trial_length,
      trial_interval_unit: 'days'
    )
  end

  def update_on_recurly
    Recurly.subdomain = organization.recurly_subdomain
    Recurly.api_key = organization.recurly_private_key
    plan = Recurly::Plan.find(self.permalink)
    plan.name = self.name
    plan.description = self.description
    plan.unit_amount_in_cents = amount_in_cents
    plan.plan_interval_length = self.charge_every
    plan.trial_interval_length = self.free_trial_length
    plan.save
  end

  def amount_in_cents
    (amount * 100.0).round.to_i
  end
end