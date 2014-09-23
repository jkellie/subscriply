class Organization::SettingsController < Organization::BaseController
  before_action :authenticate_organizer!
  before_action :require_owner_or_super_admin

  def edit_organization_settings
  end

  def update_organization_settings
    if current_organization.update_attributes(organization_params)
      flash[:notice] = 'Settings Updated'
      redirect_to edit_organization_settings_organization_settings_path
    else
      render 'edit_organization_settings'
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :logo, :refund_policy, :customer_service_email, :customer_service_phone)
  end

end