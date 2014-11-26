class Organization::UserBillingInfoUpdater
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :user

  def initialize(user)
    @user = user
    @errors = ActiveModel::Errors.new(self)
  end

  def update(token)
    begin
      ActiveRecord::Base.transaction do
        update_on_billing(token)
        update_locally
      end
    rescue Exception => e
      errors.add(:base, e)
      false
    end
  end

  def full_errors
    errors.full_messages.to_sentence
  end

  private

  def update_on_billing(token)
    Billing::User.update_billing_info(user, token)
  end

  def update_locally
    user.update_attributes(
      card_type: billing_info.card_type,
      last_four: billing_info.last_four, 
      expiration: "#{billing_info.month} / #{billing_info.year}"
    )
  end

  def billing_info
    @billing_info ||= Billing::User.billing_info(user)
  end

end