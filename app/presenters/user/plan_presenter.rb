class User::PlanPresenter
  include ActionView::Helpers::UrlHelper
  attr_reader :plan, :user

  delegate :amount, :description, :name, :subtitle, :subscribed?, :bulletpoints, to: :plan

  def initialize(options)
    @plan = options[:plan]
    @user = options[:user]
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

  def subscribe_button
    if subscribed?(user)
      link_to 'Cancel Subscription', '#', class: 'btn-danger btn-lg btn-block btn'
    else
      link_to 'Subscribe Now', subscribe_path, class: 'btn-primary btn-lg btn-block btn' 
    end
  end

  private

  def subscribe_path
    Rails.application.routes.url_helpers.new_user_subscription_path(plan_id: plan.id)
  end

end