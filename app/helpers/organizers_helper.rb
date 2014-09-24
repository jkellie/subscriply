module OrganizersHelper

  def address_requirements
    [['Both', 'both'], ['Shipping Only', 'shipping_only'], ['Billing Only', 'billing_only']]
  end

end