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

  def sales_rep_w8_w9_status(sales_rep)
    return 'W9' if sales_rep.w9?
    return 'W8' if sales_rep.w8?
    'No'
  end

end