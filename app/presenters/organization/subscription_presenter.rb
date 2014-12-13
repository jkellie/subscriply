class Organization::SubscriptionPresenter
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TagHelper
  attr_reader :subscription

  delegate :organization, :user, :start_date, :next_bill_on, :plan, :next_ship_on,
    :location, :active?, :canceling?, :canceled?, :state, :future?, :changing_to,
      to: :subscription

  def initialize(subscription)
    @subscription = subscription
  end

  def subscription_state
    subscription.state.titleize
  end

  def transactions
    subscription.transactions.order('created_at DESC')
  end

  def user_name
    user.name.titleize
  end

  def plan_name
    plan.name.titleize
  end

  def plan_type
    plan.plan_type.titleize
  end

  def plan_amount
    number_to_currency(plan.amount)
  end

  def product_name
    plan.product.name.titleize
  end

  def show_shipping_info?
    local_pick_up? || plan.shipped?
  end

  def local_pick_up?
    plan.local_pick_up?
  end

  def location_address
    _address = "#{location_object.street_address}"
    _address += "<br/>#{location_object.street_address_2}" if location_object.street_address_2.present?
    _address += "<br/>#{location_object.city}, #{location_object.state} #{location_object.zip}"
    _address.titleize
  end

  def location_name
    location.name.titleize
  end

  def status_label
    if future?
      content_tag(:span, state.upcase, class: 'label label-success')
    elsif active?
      content_tag(:span, state.upcase, class: 'label label-success')
    elsif canceling?
      content_tag(:span, state.upcase, class: 'label label-default')
    elsif canceled?
      content_tag(:span, state.upcase, class: 'label label-warning')
    end
  end

  def start_date
    subscription.start_date.try(:strftime, '%m/%-e/%y')
  end

  def next_bill_on
    subscription.next_bill_on.try(:strftime, '%m/%-e/%y')
  end

  def next_ship_on
    subscription.next_ship_on.try(:strftime, '%m/%-e/%y')
  end

  def canceled_on
    subscription.canceled_on.try(:strftime, '%m/%-e/%y')
  end

  def renewal_changable?
    active? || canceling? || future?
  end

  def cancelable?
    active? || future?
  end

  def changing?
    changing_to.present?
  end

  def changing_status
    content_tag(:p, "Subscription changing to #{changing_to_plan_name} at next renewal.", class: 'alert alert-success')
  end

  private

  def changing_to_plan_name
    Plan.find(changing_to).name
  end

  def location_object
    return user if plan.shipped?
    return location if plan.local_pick_up?
  end

end
