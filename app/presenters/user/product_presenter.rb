class User::ProductPresenter
  include ::UserProductHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  attr_reader :user, :product
  delegate :name, :image, :description, to: :product
  
  def initialize(options)
    @user = options[:user]
    @product = options[:product]
  end

  def plans
    product.plans.visible.order('amount')
  end

  def status_label
    content_tag :span, product_status(product), class: "label label-#{product_class(product)}"
  end

  def next_charge
    return active_subscription.next_bill_on.strftime('%m/%d/%Y') if active_subscription
    'N/A'
  end

  def plan_name
    return active_subscription.plan.name if active_subscription
    return canceling_subscription.plan.name if canceling_subscription
    'None'
  end

  def subscription_link
    if active_subscription
      link_to 'Edit Subscription', edit_user_subscription_path(active_subscription), class: 'btn btn-default', style: 'margin: 20px 0'
    elsif canceling_subscription
        link_to 'Edit Subscription', edit_user_subscription_path(canceling_subscription), class: 'btn btn-default', style: 'margin: 20px 0'
    else
      link_to 'Subscribe Now!', user_product_path(product), class: 'btn btn-primary', style: 'margin: 20px 0'
    end
  end

  def changing_at_renewal
    content_tag :span, 'Changing at renewal', class: 'label label-primary' if changing?
  end

  def active_subscription
    @active_subscription ||= user.active_subscription_for_product(product)
  end

  def canceling_subscription
    @canceling_subscription ||= user.canceling_subscription_for_product(product)
  end

  private

  def changing?
    active_subscription && active_subscription.changing?
  end

  def edit_user_subscription_path(subscription)
    Rails.application.routes.url_helpers.edit_user_subscription_path(subscription)
  end

  def user_product_path(product)
    Rails.application.routes.url_helpers.user_product_path(product)
  end

end