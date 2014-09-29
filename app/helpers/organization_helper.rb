module OrganizationHelper
  
  def super_admin_check_box_disabled?(current_organization, current_organizer, organizer)
    current_organization.account_owner == organizer ||
    current_organizer == organizer ||
    !current_organizer.super_admin?
  end

  def can_delete_organizer?(current_organization, current_organizer, organizer)
    organizer != current_organizer &&
    current_organization.account_owner != organizer && 
    current_organizer.super_admin?
  end

end