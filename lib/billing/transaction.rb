module Billing::Transaction

  def self.transaction_module
    Recurly::Transaction
  end

  def self.transaction_on_billing(organization, id)
    Billing.with_lock(organization) do
      transaction_module.find(id)
    end
  end
  
end
