class User::RegistrationsController < Devise::RegistrationsController
  include SubdomainHelpers
  layout 'user'
  before_filter :update_sanitized_params

  def create
    super
    create_on_billing
  end

  protected

  def create_on_billing
    Billing::User.create(resource.reload)
  end

  def after_sign_up_path_for(resource)
    '/'
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation).merge(organization_id: current_organization.id)
    end
    
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:member_number, :avatar, :first_name, :last_name, :email,
       :street_address, :street_address_2, :city, :state_code, :zip,
       :phone_number, :password, :password_confirmation, :current_password)
    end
  end

end
