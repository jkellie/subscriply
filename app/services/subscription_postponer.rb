class SubscriptionPostponer
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :subscription

  def initialize(subscription)
    @subscription = subscription
    @errors = ActiveModel::Errors.new(self)
  end

  def postpone(renewal_date)
    begin
      ActiveRecord::Base.transaction do
        postpone_on_billing(renewal_date)
        update_local_subscription(renewal_date)
      end
    rescue Exception => e
      errors.add(:base, e.message)
      false
    end 
  end

  def full_errors
    errors.full_messages.to_sentence
  end

  private

  def postpone_on_billing(renewal_date)
    Billing::Subscription.postpone(subscription, renewal_date)
  end

  def update_local_subscription(renewal_date)
    subscription.update!(next_bill_on: renewal_date)
  end

end
