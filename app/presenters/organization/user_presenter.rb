class Organization::UserPresenter
  include ActionView::Helpers::TagHelper
  attr_reader :user

  delegate :name, :id, :email, :created_at, :phone_number, :state, :open?, :closed?, :pending?, to: :user
  delegate :organization, to: :user

  def initialize(user)
    @user = user
  end

  def notes
    user.notes.order('created_at DESC')
  end

  def member_number
    return user.member_number if user.member_number
    'n/a'
  end

  def address
    _address = "#{user.street_address}"
    _address += "<br/>#{user.street_address_2}" if user.street_address_2.present?
    _address += "<br/>#{user.city}, #{user.state_code} #{user.zip}"
    _address
  end

  def status_label
    if open?
      content_tag(:span, state.upcase, class: 'label label-success')
    elsif closed?
      content_tag(:span, state.upcase, class: 'label label-danger')
    elsif pending?
      content_tag(:span, state.upcase, class: 'label label-warning')
    end
  end

  def has_sales_rep?
    user.sales_rep
  end

  def sales_rep_name
    user.sales_rep.name
  end

  def sales_rep_number
    user.sales_rep.member_number
  end

end
