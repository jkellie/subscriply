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
end
