class SubscriptionCreator
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :errors, :organization
  attr_accessor :sales_rep_id, :member_number, :phone_number, :email, :first_name, 
    :last_name, :street_address, :street_address_2, :state_code, :city, :zip
  attr_accessor :start_date, :product_id, :plan_id, :location_id
  attr_accessor :name_on_card, :card_number, :expiration_month, :expiration_year, :cvv, 
    :billing_street_address, :billing_street_address_2, :billing_city, :billing_state_code, :billing_zip

  def initialize(options)
    @organization = options[:organization]
    @errors = ActiveModel::Errors.new(self)
  end

  def attributes=(attributes)
    attributes.each { |k, v| self.send("#{k}=", v) }
  end

  def create
    create_user
    create_subscription
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

  private

  def create_user
    @user = User.invite!(user_params)
  end

  def user_params
    {
      email: email, 
      first_name: first_name, 
      last_name: last_name, 
      phone_number: phone_number, 
      street_address: street_address,
      street_address_2: street_address_2,
      zip: zip,
      state_code: state_code,
      city: city,
      sales_rep_id: sales_rep_id,
      member_number: member_number,
      organization_id: organization.id
    }
  end

  def create_subscription
    
  end

end