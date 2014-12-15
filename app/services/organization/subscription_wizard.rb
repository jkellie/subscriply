class Organization::SubscriptionWizard
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :errors, :organization, :user, :subscription, :billing_subscription
  attr_accessor :recurly_token, :first_name, :last_name, :card_number, :expiration_month, :expiration_year, :cvv, 
    :billing_street_address, :billing_street_address_2, :billing_city, :billing_state_code, :billing_zip,
    :product_id
  
  delegate :sales_rep_id, :sales_rep_id=, :member_number, :member_number=, :phone_number, :phone_number=,
    :email, :email=, :first_name, :first_name=,  :last_name, :last_name=, :street_address, :street_address=,
    :street_address_2, :street_address_2=, :state_code, :state_code=, :city, :city=, :zip, :zip=, 
      to: :user
  
  delegate :start_date, :start_date=, :plan_id, :plan_id=, :location_id, :location_id=, 
    to: :subscription

  def initialize(options)
    @organization = options[:organization]
    @user = User.new(organization_id: @organization.id)
    @subscription = Subscription.new(organization_id: @organization.id)
    @errors = ActiveModel::Errors.new(self)
  end

  def attributes=(attributes)
    attributes.each { |k, v| self.send("#{k}=", v) }
  end

  def create
    if is_valid?
      begin
        ActiveRecord::Base.transaction do
          create_user
          create_user_on_recurly
          create_subscription
          create_subscription_on_recurly
          update_cached_billing_info
          update_next_ship_date
        end
      rescue Exception => e
        errors.add(:base, e)
        add_errors_and_return_false
      end
    else
      add_errors_and_return_false
    end
  end

  def errors_to_sentence
    errors.full_messages.flatten.join('. ')
  end

  def sales_reps
    organization.users.is_sales_rep.order('first_name ASC')
  end

  def locations
    organization.locations.order('name ASC')
  end

  def plans
    organization.plans.order('name ASC')
  end

  def products
    organization.products.order('name ASC')
  end

  def persisted?
    false
  end

  def show_shipping_info?
    ['both', 'shipping_only'].include?(organization.address_requirement)
  end

  def show_billing_info?
    ['both', 'billing_only'].include?(organization.address_requirement)
  end

  private

  def add_errors_and_return_false
    add_errors
    return false
  end

  def add_errors
    user.errors.messages.each { |e| errors.add(e.first.to_sym, e.second.first) }
    subscription.errors.messages.each { |e| errors.add(e.first.to_sym, e.second.first) }
  end

  def is_valid?
    user_valid = user.valid?
    subscription_valid = subscription.valid?
    user_valid && subscription_valid
  end

  def create_user
    user.save!
  end

  def create_user_on_recurly
    Billing::User.create(user.reload)
  end

  def create_subscription
    subscription.user = user
    subscription.save!
  end

  def create_subscription_on_recurly
    @billing_subscription = Billing::Subscription.create_with_token(subscription.reload, recurly_token)
  end
  
  def update_cached_billing_info
    user.update!({
      card_type: billing_info.card_type,
      last_four: billing_info.last_four,
      expiration: "#{billing_info.month} / #{billing_info.year}"
    })
    subscription.update!({
      uuid: billing_subscription.uuid,
      state: billing_subscription.state,
      next_bill_on: billing_subscription.current_period_ends_at,
      start_date: billing_subscription.activated_at
    })
  end

  def billing_info
    @billing_info ||= Billing::User.billing_info(user)
  end

  def update_next_ship_date
    subscription.update!(next_ship_on: next_ship_on)
  end

  def next_ship_on
    NextShipDateCalculator.new(subscription).calculate
  end

end