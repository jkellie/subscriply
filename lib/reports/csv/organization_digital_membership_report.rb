class Reports::CSV::OrganizationDigitalMembershipReport < Reports::CSV::Report
  def columns
    %w(user_sales_rep
    user_member_number
    user_first_name
    user_last_name
    user_email
    plan_name)
  end

  def row(object)
    [
      object.user.sales_rep.try(:name),
      object.user.first_name,
      object.user.last_name,
      object.user.email,
      object.plan.name
    ]
  end
end