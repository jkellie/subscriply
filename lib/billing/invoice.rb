module Billing::Invoice

  def self.invoice_module
    Recurly::Invoice
  end

  def self.as_pdf(organization, invoice_number)
    invoice_on_billing(organization, invoice_number, :pdf)
  end

  def self.invoice_on_billing(organization, invoice_number, format=nil)
    Billing.with_lock(organization) do
      invoice_module.find(invoice_number, format: format)
    end
  end
  
end
