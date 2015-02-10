class Organization::DashboardPresenter
  attr_reader :organization, :plan_id, :start_date, :end_date
  delegate :subscriptions, :transactions, to: :organization



  def initialize(options)
    @organization = options[:organization]
    @plan_id = options[:plan_id]
    set_dates(start_date: options[:start_date], end_date: options[:end_date])
  end

  def plans
    organization.plans.order('name ASC')
  end

  def sales_this_period
    _transactions = transactions.successful.charge
    _transactions = _transactions.by_plan(plan_id) if plan?
    _transactions = _transactions.between(start_date, end_date)
    _transactions.sum(:amount_in_cents) / 100
  end

  def total_subscriptions_count
    total_subscriptions.count
  end

  def total_subscriptions_data
    ({}).tap do |data|
      (start_date.to_date..end_date.to_date).each do |day|
        data[day.strftime('%Y/%m/%d')] = total_on_day(day)
      end
    end
  end

  def new_this_period_data
    ({}).tap do |data|
      (start_date.to_date..end_date.to_date).each do |day|
        data[day.strftime('%Y/%m/%d')] = new_on_day(day)
      end
    end
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

  private

  def plan?
    @plan_id.present?
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

    _subscriptions
  end

  def canceled_this_period
    _subscriptions = subscriptions.canceled_between(start_date, end_date)
    _subscriptions = _subscriptions.where(plan_id: plan_id) if plan?

    _subscriptions
  end

  def total_subscriptions
    _subscriptions = subscriptions.active
    _subscriptions = _subscriptions.where(plan_id: plan_id) if plan?

    _subscriptions
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

  def subscription_total_record(day)
    record = SubscriptionTotalRecord.where(organization: @organization, created_at: day)
    record = record.where(plan_id: @plan_id) if plan?
    record.first.try(:total).to_i
  end

end
