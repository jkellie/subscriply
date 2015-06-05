class Reports::CSV::ShippingNotificationReport < Reports::CSV::Report
  def columns
    %w(
    user_member_number
    user_first_name
    user_last_name
    user_address1
    user_address2
    user_city
    user_state
    user_zip_code
    user_email
    plan_name,
    product_name,
    shipping_method,
    shipping_model,
    weight)
  end

  def row(subscription)
    [
      subscription.user.member_number,
      subscription.user.first_name,
      subscription.user.last_name,
      subscription.user.street_address,
      subscription.user.street_address_2,
      subscription.user.city,
      subscription.user.state,
      subscription.user.zip,
      subscription.user.email,
      subscription.plan.name,
      subscription.product.name,
      nil,
      nil,
      nil
    ]
  end
end