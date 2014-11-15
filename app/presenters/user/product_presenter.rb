class User::ProductPresenter
  include ::UserProductHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  attr_reader :user, :product
  delegate :name, :image, :plans, to: :product
  
  def initialize(options)
    @user = options[:user]
    @product = options[:product]
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
    'None'
  end

  def subscription_link
    if active_subscription
      link_to 'Edit', '#'
    else
      link_to 'Subscribe Now!', '#'
    end
  end

  private

  def active_subscription
    @active_subscription ||= user.active_subscription_for_product(product)
  end

end