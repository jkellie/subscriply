module Billing
  class Notification::ExpiredSubscription < Struct.new(:options)
    
    def perform
      subscription.cancel!
    end

    private

    def subscription
      ::Subscription.find_by_uuid(options[:subscription_uuid])
    end
    
  end
end