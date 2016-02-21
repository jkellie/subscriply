module Billing
  class Notification::UpdatedSubscription < Struct.new(:options)
    
    def perform
      subscription.update_attributes({
        plan: new_plan,
        next_bill_on: next_bill_on,
        changing_to: nil,
        changing_on: nil
      })
      subscription.reload.update_attributes(next_ship_on: next_ship_on)
    end
    handle_asynchronously :perform

    private

    def subscription
      ::Subscription.find_by_uuid(options[:subscription_uuid])
    end

    def subscription_on_billing
      Billing::Subscription.subscription_on_billing(subscription)
    end

    def new_plan
      @new_plan ||= Plan.where(product_id: subscription.product.id, code: plan_code).first
    end

    def plan_code
      subscription_on_billing.plan.plan_code.split('_').last
    end

    def next_ship_on
      NextShipDateCalculator.new(subscription.reload).calculate
    end

    def next_bill_on
      subscription_on_billing.current_period_ends_at
    end
    
  end
end