class Organization::SubscriptionCanceler
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :subscription

  def initialize(subscription)
    @subscription = subscription
    @errors = ActiveModel::Errors.new(self)
  end

  def cancel
    begin
      ActiveRecord::Base.transaction do
        cancel_subscription_on_billing
        cancel_subscription_locally
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

  def cancel_subscription_on_billing
    Billing::Subscription.cancel(subscription)
  end

  def cancel_subscription_locally
    subscription.canceling!
    subscription.update!(canceled_on: Time.current.to_date)
  end

end