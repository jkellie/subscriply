module Billing
  class Notification::FailedPayment < Struct.new(:options)
    
    def perform
      create_transaction
      update_subscription
    end
    handle_asynchronously :perform

    private

    def create_transaction
      ::Transaction.create({
        transaction_type: 'charge',
        user_id:          user.id,
        subscription_id:  subscription.id,
        invoice_id:       invoice.id,
        amount_in_cents:  billing_transaction.amount_in_cents,
        created_at:       billing_transaction.created_at,
        state:            billing_transaction.status.downcase,
        uuid:             billing_transaction.uuid
      })
    end

    def update_subscription
      subscription.update(next_ship_on: next_ship_on, next_bill_on: next_bill_on)
    end

    def user
      @user ||= ::User.find_by_uuid(user_uuid)
    end

    def subscription
      @subscription ||= ::Subscription.find_by_uuid(billing_transaction.subscription.uuid)
    end

    def subscription_on_billing
      Billing::Subscription.subscription_on_billing(subscription)
    end

    def invoice
      if _invoice = ::Invoice.find_by_uuid(invoice_on_billing.uuid)
        return _invoice
      else
        return ::Invoice.create({
          user_id:        user.id,
          number:         invoice_on_billing.invoice_number,
          total_in_cents: invoice_on_billing.total_in_cents,
          created_at:     invoice_on_billing.created_at,
          state:          invoice_on_billing.state,
          uuid:           invoice_on_billing.uuid
        })
      end
    end

    def invoice_on_billing
      @invoice_on_billing ||= billing_transaction.invoice
    end

    def billing_transaction
      @billing_transaction ||= Billing::Transaction.transaction_on_billing(user.organization, transaction_uuid)
    end

    def next_ship_on
      NextShipDateCalculator.new(subscription).calculate  
    end

    def next_bill_on
      subscription_on_billing.current_period_ends_at
    end

    def user_uuid
      options[:user_uuid]
    end

    def transaction_uuid
      options[:transaction_uuid]
    end
    
  end
end