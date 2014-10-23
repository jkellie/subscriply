class SubscriptionCreator
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :subscription, :billing_subscription, :errors
  delegate :user, to: :subscription

  def initialize(options)
    @subscription = Subscription.new(options)
    @errors = ActiveModel::Errors.new(self)
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        create_subscription
        create_subscription_on_billing
        update_subscription_locally
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

end