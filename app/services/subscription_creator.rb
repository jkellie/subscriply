class SubscriptionCreator
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :errors, :organization, :user, :subscription
  attr_accessor :recurly_token, :first_name, :last_name, :card_number, :expiration_month, :expiration_year, :cvv, 
    :billing_street_address, :billing_street_address_2, :billing_city, :billing_state_code, :billing_zip,
    :product_id
  
  delegate :sales_rep_id, :sales_rep_id=, :member_number, :member_number=, :phone_number, :phone_number=,
    :email, :email=, :first_name, :first_name=,  :last_name, :last_name=, :street_address, :street_address=,
    :street_address_2, :street_address_2=, :state_code, :state_code=, :city, :city=, :zip, :zip=, 
      to: :user
  delegate :start_date, :start_date=, :plan_id, :plan_id=, :location_id, :location_id=, 
    to: :subscription

  @@lock = Mutex.new

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

  private

  def add_errors_and_return_false
    add_errors
    return false
  end

  def is_valid?
    user_valid = user.valid?
    subscription_valid = subscription.valid?
    user_valid && subscription_valid
  end

  def add_errors
    user.errors.messages.each { |e| errors.add(e.first.to_sym, e.second.first) }
    subscription.errors.messages.each { |e| errors.add(e.first.to_sym, e.second.first) }
  end

  def create_user
    user.save
  end

  def create_user_on_recurly
    @@lock.synchronize do
      Recurly.subdomain = organization.recurly_subdomain
      Recurly.api_key = organization.recurly_private_key
      Recurly::Account.create(
        account_code: user.reload.uuid,
        email:        user.email,
        first_name:   user.first_name,
        last_name:    user.last_name
      )
    end
  end

  def create_subscription
    subscription.user = user
    subscription.save
  end

  def create_subscription_on_recurly
    @@lock.synchronize do
      Recurly.subdomain = organization.recurly_subdomain
      Recurly.api_key = organization.recurly_private_key
      Recurly::Subscription.create! plan_code: subscription.plan.permalink,
        account: {
          account_code: user.uuid,
          billing_info: { token_id: recurly_token }
        }
    end
  end

end