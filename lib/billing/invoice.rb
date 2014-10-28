module Billing::Invoice

  def self.invoice_module
    Recurly::Invoice
  end

  def self.invoice_on_billing(organization, number)
    Billing.with_lock(organization) do
      invoice_module.find(number)
    end
  end
  
end
