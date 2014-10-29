module Billing
  class Notification::ClosedInvoice < Struct.new(:options)
    
    def perform
      if invoice = ::Invoice.find_by_uuid(billing_invoice.uuid)
        invoice.update_attributes(
          state:          billing_invoice.state,
          total_in_cents: billing_invoice.total_in_cents
        )
      else
        ::Invoice.create({
          user_id:        user.id,
          number:         billing_invoice.invoice_number,
          total_in_cents: billing_invoice.total_in_cents,
          created_at:     billing_invoice.created_at,
          state:          billing_invoice.state,
          uuid:           billing_invoice.uuid
        })
      end
    end

    def user
      ::User.find_by_uuid(user_uuid)
    end

    def billing_invoice
      @billing_invoice ||= Billing::Invoice.invoice_on_billing(user.organization, invoice_number)
    end

    def user_uuid
      options[:user_uuid]
    end

    def invoice_number
      options[:invoice_number]
    end
    
  end
end