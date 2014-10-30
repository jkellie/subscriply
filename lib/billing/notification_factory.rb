module Billing
  class NotificationFactory
    attr_reader :body

    class << self
      def build_notification(body)
        @body = Hash.from_xml(body)

        case notification_type
        when 'new_invoice_notification'
          return Billing::Notification::NewInvoice.new(new_invoice_params)
        when 'closed_invoice_notification'
          return Billing::Notification::ClosedInvoice.new(closed_invoice_params)
        when 'past_due_invoice_notification'
          return Billing::Notification::PastDueInvoice.new(past_due_invoice_params)
        when 'successful_payment_notification'
          return Billing::Notification::SuccessfulPayment.new(successful_payment_params)
        when 'failed_payment_notification'
          return Billing::Notification::FailedPayment.new(failed_payment_params)
        when 'successful_refund_notification'
          return Billing::Notification::SuccessfulRefund.new(successful_refund_params)
        end
      end

      private

      def notification_type
        @body.keys.first
      end

      def new_invoice_params
        {
          user_uuid:      @body['new_invoice_notification']['account']['account_code'],
          invoice_number: @body['new_invoice_notification']['invoice']['invoice_number']
        }
      end

      def closed_invoice_params
        {
          user_uuid:      @body['closed_invoice_notification']['account']['account_code'],
          invoice_number: @body['closed_invoice_notification']['invoice']['invoice_number']
        }
      end

      def past_due_invoice_params
        {
          user_uuid:      @body['past_due_invoice_notification']['account']['account_code'],
          invoice_number: @body['past_due_invoice_notification']['invoice']['invoice_number']
        }
      end

      def successful_payment_params
        {
          user_uuid:         @body['successful_payment_notification']['account']['account_code'],
          transaction_uuid:  @body['successful_payment_notification']['transaction']['id']
        }
      end

      def failed_payment_params
        {
          user_uuid:         @body['failed_payment_notification']['account']['account_code'],
          transaction_uuid:  @body['failed_payment_notification']['transaction']['id']
        }
      end

      def successful_refund_params
        {
          user_uuid:         @body['successful_refund_notification']['account']['account_code'],
          transaction_uuid:  @body['successful_refund_notification']['transaction']['id']
        }
      end

    end

  end
end
