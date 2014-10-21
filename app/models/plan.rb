class Plan < ActiveRecord::Base
  belongs_to :organization
  belongs_to :product

  def permalink
    "#{product.prepend_code}_#{self.code}"
  end

  def deletable?
    false
  end

  def trial?
    free_trial_length > 0
  end

  def local_pick_up?
    plan_type == 'local_pick_up'
  end

  def shipped?
    plan_type == 'shipped'
  end

  def amount_in_cents
    (amount * 100.0).round.to_i
  end

  def create_on_recurly
    Billing::Plan.create(self)
  end

  def update_on_recurly
    Billing::Plan.update(self)
  end

end