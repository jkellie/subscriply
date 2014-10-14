module Billing

  module User    
    def self.create(user)
      Billing.with_lock(user.organization) do
        Recurly::Account.create(
          account_code: user.uuid,
          email:        user.email,
          first_name:   user.first_name,
          last_name:    user.last_name
        )
      end
    end

    def self.update_billing_info(user)
      billing_info = billing_info(user)
      
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
        Recurly::Account.find(user.uuid)
      end
    end
  end

end