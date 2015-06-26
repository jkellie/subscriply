class Organization::ReportPresenter
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::NumberHelper

  attr_reader :organization, :plan_id, :start_date, :end_date, :plan_type, :location_id
  delegate :subscriptions, :transactions, to: :organization



  def initialize(options)
    @organization = options[:organization]
    @plan_id = options[:plan_id]
    @plan_type = options[:plan_type]
    @location_id = options[:location_id]
    set_dates(start_date: options[:start_date], end_date: options[:end_date])
  end

  def plans
    organization.plans.where(plan_type: plan_type).order('name ASC')
  end

  def locations
    organization.locations.where(id: location_ids)
  end

  def location_ids
    total_subscriptions.select(:location_id).distinct(true).map(&:location_id)
  end

  def sales_this_period_query
    _transactions = transactions.successful.charge
    _transactions = _transactions.by_plan(plan_id) if plan?
    _transactions = _transactions.between(start_date, end_date)
    _transactions = _transactions.joins(:subscription).where(subscriptions: {location_id: location_id }) if location?
    _transactions
  end

  def sales_this_period
    sales_this_period_query.sum(:amount_in_cents) / 100
  end

  def total_refunds_amount
    refunds_this_period.sum(:amount_in_cents) / 100
  end

  def total_subscriptions_count
    total_subscriptions.count
  end

  def total_subscriptions_data
    report_end_date = if end_date.to_date == Date.today
      end_date.to_date.yesterday
    else
      end_date
    end

    ({}).tap do |data|
      (start_date.to_date..report_end_date.to_date).each do |day|
        data[day.strftime('%Y/%m/%d')] = total_on_day(day)
      end
    end
  end

  def declined_this_period_data
    ({}).tap do |data|
      (start_date.to_date..end_date.to_date).each do |day|
        data[day.strftime('%Y/%m/%d')] = declined_on_day(day)
      end
    end
  end

  def declined_this_period_count
    declines_this_period.count
  end

  def new_this_period_data
    ({}).tap do |data|
      (start_date.to_date..end_date.to_date).each do |day|
        data[day.strftime('%Y/%m/%d')] = new_on_day(day)
      end
    end
  end

  def total_successful_charges
    successful_charges_this_period.count
  end

  def new_this_period_count
    new_this_period.count
  end

  def canceled_this_period_data
    ({}).tap do |data|
      (start_date.to_date..end_date.to_date).each do |day|
        data[day.strftime('%Y/%m/%d')] = canceled_on_day(day)
      end
    end
  end

  def canceled_this_period_count
    canceled_this_period.count
  end

  def start_date_friendly
    @start_date.strftime('%b %d, %Y')
  end

  def end_date_friendly
    @end_date.strftime('%b %d, %Y')
  end

  def filename
    "#{plan_type}_#{@start_date.strftime('%Y%m%d')}_#{@end_date.strftime('%Y%m%d')}"
  end

  def to_csv
    handler = case plan_type
    when 'digital'
      Reports::CSV::OrganizationDigitalMembershipReport
    when 'local_pick_up'
      Reports::CSV::OrganizationLocalPickupReport
    when 'shipped'
      Reports::CSV::OrganizationDirectShippingReport
    end
    handler.to_csv(successful_charges_this_period.map(&:subscription))
  end

  def change_up?
     total_subscriptions_count > total_on_day(end_date.to_date)
  end

  def change_direction
    change_up? ? 'up' : 'down'
  end

  def total_change_ratio
    last_total = total_on_day(end_date.to_date)

    if last_total == 0
      0
    else
      (total_subscriptions_count - last_total).abs.to_d / last_total.to_d
    end
  end



  private

  def plan?
    @plan_id.present?
  end

  def plan_type?
    @plan_type.present?
  end

  def location?
    @location_id.present?
  end

  def set_dates(dates)
    set_start_date(dates[:start_date])
    set_end_date(dates[:end_date])
  end

  def set_start_date(start_date)
    if start_date.present?
      @start_date = ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(start_date.to_s).at_beginning_of_day)
    else
      @start_date = Time.zone.now.at_beginning_of_month
    end
  end

  def set_end_date(end_date)
    if end_date.present?
      @end_date = ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(end_date.to_s).at_end_of_day)
    else
      @end_date = Time.zone.now
    end
  end

  def new_this_period
    _subscriptions = subscriptions.between(start_date, end_date)
    _subscriptions = _subscriptions.where(plan_id: plan_id) if plan?
    _subscriptions = _subscriptions.where(location_id: location_id) if location?
    _subscriptions = _subscriptions.joins(:plan).where(plans: {plan_type: plan_type}) if plan_type?
    _subscriptions
  end

  def canceled_this_period
    _subscriptions = subscriptions.canceled_between(start_date, end_date)
    _subscriptions = _subscriptions.where(plan_id: plan_id) if plan?
    _subscriptions = _subscriptions.where(location_id: location_id) if location?
    _subscriptions = _subscriptions.joins(:plan).where(plans: {plan_type: plan_type}) if plan_type?
    _subscriptions
  end

  def total_subscriptions_for_report
    _subscriptions = subscriptions.active
    _subscriptions = _subscriptions.between(start_date, end_date)
    _subscriptions = _subscriptions.where(location_id: location_id) if location?    
    _subscriptions = _subscriptions.where(plan_id: plan_id) if plan?
    _subscriptions = _subscriptions.joins(:plan).where(plans: {plan_type: plan_type}) if plan_type?
    _subscriptions
  end

  def total_subscriptions
    _subscriptions = subscriptions.active
    _subscriptions = _subscriptions.where(location_id: location_id) if location?    
    _subscriptions = _subscriptions.where(plan_id: plan_id) if plan?
    _subscriptions = _subscriptions.joins(:plan).where(plans: {plan_type: plan_type}) if plan_type?
    _subscriptions
  end

  def successful_charges_this_period
    _transactions = transactions.successful.charge
    _transactions = _transactions.by_plan(plan_id) if plan?
    _transactions = _transactions.between(start_date, end_date)
    _transactions = _transactions.joins(subscription: :plan).where(plans: { plan_type: plan_type})  if plan_type?
    _transactions = _transactions.joins(:subscription).where(subscriptions: {location_id: location_id }) if location?
    _transactions
  end

  def declines_this_period
    _transactions = transactions.declined
    _transactions = _transactions.by_plan(plan_id) if plan?
    _transactions = _transactions.between(start_date, end_date)
    _transactions = _transactions.joins(subscription: :plan).where(plans: { plan_type: plan_type})  if plan_type?
    _transactions = _transactions.joins(:subscription).where(subscriptions: {location_id: location_id }) if location?
    _transactions
  end

  def refunds_this_period
    _transactions = transactions.successful.refund
    _transactions = _transactions.by_plan(plan_id) if plan?
    _transactions = _transactions.between(start_date, end_date)
    _transactions = _transactions.joins(subscription: :plan).where(plans: { plan_type: plan_type})  if plan_type?
    _transactions = _transactions.joins(:subscription).where(subscriptions: {location_id: location_id }) if location?    
    _transactions
  end

  def new_on_day(day)
    [new_this_period.where(start_date: day).count, 0].max
  end

  def canceled_on_day(day)
    [canceled_this_period.where(canceled_on: day).count, 0].max
  end

  def total_on_day(day)
    [subscription_total_record(day), 0].max
  end

  def declined_on_day(day)
    [declines_this_period.between(day.at_beginning_of_day, day.at_end_of_day).count, 0].max
  end

  def subscription_total_record(day)
    record = SubscriptionTotalRecord.where(organization: @organization, created_at: day)
    record = record.where(plan_id: @plan_id) if plan?
    record = record.joins(:plan).where(plans: { plan_type: plan_type}) if plan_type?
    record = record.joins(plan: :subscriptions).where(subscriptions: {location_id: location_id}) if location?
    record.first.try(:total).to_i
  end

end
