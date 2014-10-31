module Billing
  class Notification::RenewedSubscription < Struct.new(:options)
    
    def perform
      subscription.activate!
      subscription.update_attributes({
        next_bill_on: next_bill_on,
        next_ship_on: next_ship_on
      })
    end
    handle_asynchronously :perform

    private

    def subscription
      ::Subscription.find_by_uuid(options[:subscription_uuid])
    end

    def subscription_on_billing
      Billing::Subscription.subscription_on_billing(subscription)
    end

    def next_ship_on
      NextShipDateCalculator.new(subscription).calculate
    end

    def next_bill_on
      subscription_on_billing.current_period_ends_at
    end
    
  end
end