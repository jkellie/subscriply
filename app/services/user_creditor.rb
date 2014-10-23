class UserCreditor
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :user
  attr_accessor :amount, :description, :accounting_code

  def initialize(user)
    @user = user
    @errors = ActiveModel::Errors.new(self)
  end

  def attributes=(attributes)
    attributes.each { |k, v| self.send("#{k}=", v) }  
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        create_credit_on_billing
        create_credit_locally
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

  def create_credit_locally
    Billing::User.credit(user, credit_attributes)
  end

  def create_local_credit
    # pending on credit model.
    true
  end

  def credit_attributes
    {
      amount:           unit_amount_in_cents,
      description:      description,
      accounting_code:  accounting_code
    }
  end

  def unit_amount_in_cents
    (amount.to_i * 100.0).round.to_i
  end

end