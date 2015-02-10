class Reports::CSV::OrganizationLocalPickupReport < Reports::CSV::Report
  def columns
    %w(location_name
    location_address1
    location_address2
    location_city
    location_state
    location_zip_code
    user_sales_rep
    user_member_number
    user_first_name
    user_last_name
    user_email
    plan_name)
  end

  def row(object)
    #assuming subscriptions
    [
      object.location.name,
      object.location.street_address,
      object.location.street_address_2,
      object.location.city,
      object.location.state,
      object.location.zip,
      object.user.sales_rep.name,
      object.user.member_number,
      object.user.first_name,
      object.user.last_name,
      object.user.email,
      object.plan.name
    ]
  end
end