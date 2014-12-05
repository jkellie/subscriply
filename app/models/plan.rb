class Plan < ActiveRecord::Base
  belongs_to :organization
  belongs_to :product
  has_many :bulletpoints
  accepts_nested_attributes_for :bulletpoints, reject_if: :all_blank, allow_destroy: true

  validate :can_add_new_plan

  PLAN_LIMIT = 6

  def subscribed?(user)
    user.subscriptions.active.where(plan_id: self.id).any?
  end

  def permalink
    "#{product.prepend_code}_#{self.code}"
  end

  def to_s
    "#{product.prepend_code.upcase} #{name}"
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

  def digital?
    plan_type == 'digital'
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

  def hide_location_info?
    shipped? || digital?
  end

  def hide_shipping_info?
    digital? || local_pick_up?
  end

  private

  def can_add_new_plan
    errors.add(:base, 'You cannot add more than 6 plans to a product') unless can_add_new_plan?
  end

  def can_add_new_plan?
    product.plans_count < PLAN_LIMIT
  end

end