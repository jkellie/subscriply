module Billing::Invoice

  def self.invoice_module
    Recurly::Invoice
  end

  def self.invoice_on_billing(organization, uuid)
    Billing.with_lock(organization) do
      invoice_module.find(uuid)
    end
  end
  
end
