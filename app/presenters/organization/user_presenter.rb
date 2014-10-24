class Organization::UserPresenter
  include ActionView::Helpers::TagHelper
  attr_reader :user

  delegate :organization, :name, :id, :email, :created_at, :phone_number,
    :state, :open?, :closed?, :pending?, :last_four, :card_type, :expiration, to: :user

  def initialize(user)
    @user = user
  end

  def notes
    user.notes.order('created_at DESC')
  end

  def subscriptions
    user.subscriptions.order('created_at DESC')
  end

  def address
    _address = "#{user.street_address}"
    _address += "<br/>#{user.street_address_2}" if user.street_address_2.present?
    _address += "<br/>#{user.city}, #{user.state_code} #{user.zip}"
    _address
  end

  def has_sales_rep?
    user.sales_rep
  end

  def has_billing_info?
    card_type && last_four && expiration
  end

  def member_number
    return user.member_number if user.member_number
    'n/a'
  end

  def product_status_labels
    ('').tap do |labels|
      organization.products.each do |product|
        labels << content_tag(:span, product.prepend_code.upcase, class: "label label-#{product_class(product)}")
      end
    end
  end

  def status_label
    if open?
      content_tag(:span, state.upcase, class: 'label label-success')
    elsif closed?
      content_tag(:span, state.upcase, class: 'label label-default')
    elsif pending?
      content_tag(:span, state.upcase, class: 'label label-warning')
    end
  end

  def sales_rep_name
    user.sales_rep.name
  end

  def sales_rep_number
    user.sales_rep.member_number
  end

  def products
    organization.products.order('name ASC')
  end

  def locations
    organization.locations.order('name ASC')
  end

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
