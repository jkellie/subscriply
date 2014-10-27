module Billing
  class NotificationFactory
    attr_reader :body

    class << self
      def build_notification(body)
        @body = Hash.from_xml(body)

        case notification_type
        when 'new_invoice_notification'
          return Billing::Notification::NewInvoice.new(new_invoice_params)
        end
      end

      private

      def notification_type
        @body.keys.first
      end

      def new_invoice_params
        {
          user_uuid: @body['new_invoice_notification']['account']['account_code'],
          invoice_uuid: @body['new_invoice_notification']['invoice']['uuid']
        }
      end
    end

  end
end
