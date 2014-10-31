module Billing
  class Notification::ExpiredSubscription < Struct.new(:options)
    
    def perform
      subscription.cancel!
      subscription.update(canceled_on: Date.today) unless subscription.canceled_on
    end

    private

    def subscription
      ::Subscription.find_by_uuid(options[:subscription_uuid])
    end
    
  end
end