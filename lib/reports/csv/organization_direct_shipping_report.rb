class Reports::CSV::OrganizationDirectShippingReport < Reports::CSV::Report
  def columns
    %w(user_sales_rep
    user_member_number
    user_first_name
    user_last_name
    user_address1
    user_address2
    user_city
    user_state
    user_zip_code
    user_email
    plan_name)
  end

  def row(subscription)
    [
      subscription.user.sales_rep.try(:name),
      subscription.user.member_number,
      subscription.user.first_name,
      subscription.user.last_name,
      subscription.user.street_address,
      subscription.user.street_address_2,
      subscription.user.city,
      subscription.user.state_code,
      subscription.user.zip,
      subscription.user.email,
      subscription.plan.name
    ]
  end
end