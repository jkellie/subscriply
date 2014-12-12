class User::DashboardPresenter
  attr_reader :user

  def initialize(options)
    @user = options[:user]
  end

  def products
    active_products + inactive_products
  end

  private

  def active_products
    @active_products ||= user.products.order('subscriptions.state, products.name ASC')
  end

  def active_product_ids
    active_products.pluck(:id)
  end

  def inactive_products
    user.organization.products.where.not(id: active_product_ids)
  end

end
