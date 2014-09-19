class Organization::RegistrationsController < Devise::RegistrationsController
  layout 'organizer'
  before_filter :update_sanitized_params

  protected

  def after_update_path_for(resource)
    edit_organizer_registration_path
  end

  def after_sign_up_path_for(resource)
    organization_dashboard_path(subdomain: request.subdomain)
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :avatar, :password, :password_confirmation).merge(organization_id: organization.id)
    end
    
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :avatar, :password, :password_confirmation, :current_password)
    end
  end

  def organization
    Organization.find_by_subdomain(request.subdomain)
  end
end
