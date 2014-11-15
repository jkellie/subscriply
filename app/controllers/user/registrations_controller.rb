class User::RegistrationsController < Devise::RegistrationsController
  include SubdomainHelpers
  layout 'user'
  before_filter :update_sanitized_params

  protected

  def after_sign_up_path_for(resource)
    '/'
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation).merge(organization_id: current_organization.id)
    end
    
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
    end
  end

end
