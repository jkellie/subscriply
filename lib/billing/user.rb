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
        unit_amount_in_cents: options[:amount],
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

  def self.update_cached_billing_info(user)
    billing_info = billing_info(user)
    
    # TODO: Move into service object UserBillingInfoUpdater
    user.update_attributes(
      card_type: billing_info.card_type,
      last_four: billing_info.last_four, 
      expiration: "#{billing_info.month} / #{billing_info.year}"
    )
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
