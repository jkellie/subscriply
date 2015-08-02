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
    products_with_visible_plans_ids = user.organization.plans.visible.pluck(:product_id).uniq

    user.organization.products.where(id: products_with_visible_plans_ids).where.not(id: active_product_ids)
  end

end
