class UserPresenter

  private

  def product_class(product)
    return 'success' if has_active_subscription_in_product?(product)
    return 'warning' if has_canceling_subscription_in_product?(product)
    'default'
  end

  def has_active_subscription_in_product?(product)
    product.plans.each do |plan|
      return true if user.subscriptions.active.where(plan: plan).any?
    end
    false
  end

  def has_canceling_subscription_in_product?(product)
    product.plans.each do |plan|
      return true if user.subscriptions.canceling.where(plan: plan).any?
    end
    false
  end
end