class Organization::BaseController < ApplicationController
  include SubdomainHelpers
  layout 'organizer'

  private

  def require_owner_or_super_admin
    unless current_organizer.account_owner? || current_organizer.super_admin?
      flash[:danger] = 'You must be an account owner or super admin to access this page'
      redirect_to organization_dashboard_path
    end
  end

  def require_recurly
    unless recurly_info_present? 
      flash[:danger] = 'You must enter your company\'s Recurly info before proceeding.'
      redirect_to edit_application_settings_organization_settings_path
    end
  end

  def recurly_info_present?
    current_organization.recurly_private_key.present? && 
    current_organization.recurly_public_key.present?  && 
    current_organization.recurly_subdomain.present?
  end
end
