class SubscriptionReactivator
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :subscription

  def initialize(subscription)
    @subscription = subscription
    @errors = ActiveModel::Errors.new(self)
  end

  def reactivate
    begin
      ActiveRecord::Base.transaction do
        reactivate_subscription_on_billing
        reactivate_subscription_locally
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

  def reactivate_subscription_on_billing
    Billing::Subscription.reactivate(subscription)
  end

  def reactivate_subscription_locally
    subscription.activate!
    subscription.update!(canceled_on: nil)
  end

end