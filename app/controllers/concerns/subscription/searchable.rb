module Subscription::Searchable

  private
  
  def find_subscriptions
    @subscriptions = current_organization.subscriptions
    @subscriptions = @subscriptions.search(q) if search?
    
    if search_between_invoice_dates?
      @subscriptions = @subscriptions.invoice_between(invoice_start_date, invoice_end_date)
    elsif search_a_invoice_date?
      @subscriptions = @subscriptions.where(["next_bill_on >= ?", invoice_start_date]) if invoice_start_date?
      @subscriptions = @subscriptions.where(["next_bill_on <= ?", invoice_end_date]) if invoice_end_date?
    end

    @subscriptions = @subscriptions.active if active?
    @subscriptions = @subscriptions.canceled if canceled?
    @subscriptions = @subscriptions.canceling if canceling?
    @subscriptions = @subscriptions.future if future?
    @subscriptions = @subscriptions.order('created_at DESC').page(page).per(per_page)
  end

  def active?
    params[:state] == 'Active'
  end

  def canceling?
    params[:state] == 'Canceling'
  end

  def canceled?
    params[:state] == 'Canceled'
  end

  def future?
    params[:state] == 'Future'
  end

  def q
    params[:q]
  end

  def search?
    q.present?
  end

  def page
    params[:page] || 1
  end

  def per_page
    20
  end

  def search_between_invoice_dates?
    invoice_start_date? && invoice_end_date?
  end

  def search_a_invoice_date?
    invoice_start_date? || invoice_end_date?
  end

  def invoice_start_date
    ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(params[:invoice_start_date].to_s).at_beginning_of_day)
  end

  def invoice_end_date
    ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(params[:invoice_end_date].to_s).at_end_of_day)
  end

  def invoice_start_date?
    params[:invoice_start_date].present?
  end

  def invoice_end_date?
    params[:invoice_end_date].present?
  end

end