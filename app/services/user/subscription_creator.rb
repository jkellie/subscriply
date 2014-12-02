class User::SubscriptionCreator
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :errors, :organization, :user, :subscription, :billing_subscription
  attr_accessor :recurly_token, :first_name, :last_name, :card_number, :expiration_month, :expiration_year, :cvv, 
    :billing_street_address, :billing_street_address_2, :billing_city, :billing_state_code, :billing_zip,
    :product_id

  delegate :member_number, :member_number=, :phone_number, :phone_number=,
    :email, :email=, :first_name, :first_name=,  :last_name, :last_name=, :street_address, :street_address=,
    :street_address_2, :street_address_2=, :state_code, :state_code=, :city, :city=, :zip, :zip=, 
      to: :user

  delegate :start_date, :start_date=, :plan_id, :plan_id=, :location_id, :location_id=, 
    to: :subscription

  def initialize(options)
    @organization = options[:organization]
    @user = options[:user]
    @subscription = Subscription.new(organization_id: @organization.id, start_date: Date.today)
    @errors = ActiveModel::Errors.new(self)
  end

  def attributes=(attributes)
    attributes.each { |k, v| self.send("#{k}=", v) }
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        update_user
        create_subscription
        create_subscription_on_billing
        update_subscription_locally
        update_next_ship_date
      end
    rescue Exception => e
      errors.add(:base, e)
      false
    end
  end

  def full_errors
    errors.full_messages.to_sentence.gsub('base ', '')
  end

  private

  def update_user
    user.save!
  end

  def create_subscription
    subscription.save!
  end

  def create_subscription_on_billing
    @billing_subscription = Billing::Subscription.create(subscription.reload)
  end

  def update_subscription_locally
    subscription.update!({
      uuid: billing_subscription.uuid,
      state: billing_subscription.state,
      next_bill_on: billing_subscription.current_period_ends_at,
      start_date: billing_subscription.activated_at
    })
  end

  def update_next_ship_date
    subscription.update!(next_ship_on: next_ship_on)
  end

  def next_ship_on
    NextShipDateCalculator.new(subscription).calculate
  end

end