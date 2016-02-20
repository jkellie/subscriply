class SubscriptionUpdater
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :subscription, :options

  def initialize(subscription)
    @subscription = subscription
    @errors = ActiveModel::Errors.new(self)
  end

  def update(opts)
    @options = opts
    
    begin
      ActiveRecord::Base.transaction do
        update_subscription_on_billing
        update_subscription_locally
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

  def update_subscription_on_billing
    Billing::Subscription.update(subscription, {
      plan_code: options[:plan_code],
      timeframe: options[:timeframe]
    })
  end

  def update_subscription_locally
    if update_now?
      subscription.update!(plan_id: options[:plan_id]) 
    else
      subscription.update!(changing_to: options[:plan_id])
    end
    subscription.update!(state: new_state, next_bill_on: billing_subscription.current_period_ends_at)
  end

  def new_state
    billing_subscription.state.gsub('expired', 'canceled')
  end

  def update_now?
    options[:timeframe] == 'now'
  end

  def billing_subscription
    @billing_subscription ||= Billing::Subscription.subscription_on_billing(subscription)
  end

end