module UserProductHelper
  extend ActiveSupport::Concern

  private

  def product_status(product)
    return 'Active' if has_active_subscription_in_product?(product)
    return 'Canceling' if has_canceling_subscription_in_product?(product)
    return 'Canceled' if has_canceled_subscription_in_product?(product)
    'None'
  end

  def product_class(product)
    return 'success' if has_active_subscription_in_product?(product)
    return 'warning' if has_canceling_subscription_in_product?(product)
    return 'danger' if has_canceled_subscription_in_product?(product)
    'default'
  end

  def active_subscription_in_product(product)
    product.plans.each do |plan|
      _subscription = user.subscriptions.active.where(plan: plan).first
      return _subscription
    end
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

  def has_canceled_subscription_in_product?(product)
    product.plans.each do |plan|
      return true if user.subscriptions.canceled.where(plan: plan).any?
    end
    false
  end

end