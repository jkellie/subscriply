class Organization::SubscriptionCreator
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :subscription, :billing_subscription, :errors
  delegate :user, to: :subscription

  def initialize(options)
    options[:start_date] = Date.strptime(options[:start_date], '%m/%d/%Y')
    @subscription = Subscription.new(options)
    @errors = ActiveModel::Errors.new(self)
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        create_subscription
        create_subscription_on_billing
        update_subscription_locally
        update_next_ship_date
      end
    rescue Exception => e
      errors.add(:base, e)
      false
    end
  end

  def full_errors
    errors.full_messages.to_sentence.gsub('base ', '')
  end

  private

  def create_subscription
    subscription.save!
  end

  def create_subscription_on_billing
    @billing_subscription = Billing::Subscription.create(subscription.reload)
  end

  def update_subscription_locally
    subscription.update!({
      uuid: billing_subscription.uuid,
      state: billing_subscription.state,
      next_bill_on: billing_subscription.current_period_ends_at,
      start_date: billing_subscription.activated_at
    })
  end

  def update_next_ship_date
    subscription.update!(next_ship_on: next_ship_on)
  end

  def next_ship_on
    NextShipDateCalculator.new(subscription).calculate
  end

end