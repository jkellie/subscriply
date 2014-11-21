class User::PlanPresenter
  attr_reader :plan

  delegate :amount, :description, :to_s, :subtitle, :subscribed?, to: :plan

  def initialize(plan)
    @plan = plan
  end

  def cents
    _cents = ((amount - amount.to_i).to_f * 100).to_i
    _cents = '00' if _cents == 0
    _cents
  end

  def charge_every
    return 'Per Month' if plan.charge_every.to_i == 1
    return 'Per Year' if plan.charge_every.to_i == 12
    "Per #{plan.charge_every} Months"
  end
end