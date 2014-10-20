class Organization::SubscriptionPresenter
  include ActionView::Helpers::NumberHelper
  attr_reader :subscription

  delegate :organization, :user, :state, :start_date, :next_bill_on, :plan, :location,
    to: :subscription

  def initialize(subscription)
    @subscription = subscription
  end

  def user_name
    user.name
  end

  def plan_name
    plan.name
  end

  def plan_type
    plan.plan_type
  end

  def plan_amount
    number_to_currency(plan.amount)
  end

  def show_shipping_info?
    plan.local_pick_up?
  end

  def location_address
    _address = "#{location.street_address}"
    _address += "<br/>#{location.street_address_2}" if location.street_address_2.present?
    _address += "<br/>#{location.city}, #{location.state} #{location.zip}"
    _address
  end

  def location_name
    location.name
  end


end
