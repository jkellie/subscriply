class Organization::SubscriptionTerminator
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :subscription

  def initialize(subscription)
    @subscription = subscription
    @errors = ActiveModel::Errors.new(self)
  end

  def terminate(refund_type)
    begin
      ActiveRecord::Base.transaction do
        terminate_subscription_on_billing(refund_type)
        terminate_subscription_locally
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

  def terminate_subscription_on_billing(refund_type)
    Billing::Subscription.terminate(subscription, refund_type)
  end

  def terminate_subscription_locally
    subscription.cancel!
    subscription.update!(canceled_on: Time.current.to_date, next_bill_on: nil)
  end

end