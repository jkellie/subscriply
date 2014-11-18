module Billing::User

  def self.account_module
    Recurly::Account
  end

  def self.create(user)
    Billing.with_lock(user.organization) do
      account_module.create(
        account_code: user.uuid,
        email:        user.email,
        first_name:   user.first_name,
        last_name:    user.last_name
      )
    end
  end

  def self.credit(user, options)
    Billing.with_lock(user.organization) do
      account_on_billing(user).adjustments.create(
        unit_amount_in_cents: options[:amount].to_i.abs * -1,
        description:          options[:description],
        accounting_code:      options[:accounting_code],
        currency:             'USD',
        quantity:             1
      )
    end
  end

  def self.update_billing_info(user, token)
    billing_info(user).update_attributes(token_id: token)
  end

  def self.billing_info(user)
    account_on_billing(user).billing_info
  end

  def self.account_on_billing(user)
    Billing.with_lock(user.organization) do
      account_module.find(user.uuid)
    end
  end

end
