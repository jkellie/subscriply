class SubscriptionUpdater
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :subscription

  def initialize(subscription)
    @subscription = subscription
    @errors = ActiveModel::Errors.new(self)
  end

  def update(options)
    begin
      ActiveRecord::Base.transaction do
        update_subscription_on_billing(options)
        update_subscription_locally(options)
      end
    rescue Exception => e
      errors.add(:base, e)
      false
    end
  end

  def full_errors
    errors.full_messages.to_sentence
  end

  private

  def update_subscription_on_billing(options)
    Billing::Subscription.update(subscription, {
      plan_code: options[:plan_code],
      timeframe: options[:timeframe]
    })
  end

  def update_subscription_locally(options)
    subscription.update!(plan_id: options[:plan_id]) if options[:timeframe] == 'now'
    subscription.update!(state: billing_subscription.state, next_bill_on: billing_subscription.current_period_ends_at)
  end

  def billing_subscription
    @billing_subscription ||= Billing::Subscription.subscription_on_billing(subscription)
  end
end