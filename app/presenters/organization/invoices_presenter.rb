require 'csv'

class Organization::InvoicesPresenter
  include ActionView::Helpers::NumberHelper
  attr_reader :organization, :query, :start_date, :end_date, :status, :page

  def initialize(organization, options)
    @organization = organization
    @query = options[:query]
    @start_date = ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(options[:start_date].to_s).at_beginning_of_day) if options[:start_date].present?
    @end_date = ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(options[:end_date].to_s).at_end_of_day) if options[:end_date].present?
    @status = options[:status]
    @page = options[:page]
  end

  def invoices(options={})
    _invoices = organization.invoices
    _invoices = _invoices.search(query) if query?
    _invoices = _invoices.open if open?
    _invoices = _invoices.closed if closed?

    if start_date? && end_date?
      _invoices = _invoices.between(start_date, end_date)
    elsif start_date? || end_date?
      _invoices = _invoices.where(["invoices.created_at >= ?", start_date]) if start_date?
      _invoices = _invoices.where(["invoices.created_at >= ?", end_date]) if end_date?
    else
      _invoices = _invoices
    end
    
    if options[:ignore_pagination] == true
      _invoices = _invoices.order('invoices.created_at desc')
    else
      _invoices = _invoices.order('invoices.created_at desc').page(page).per(per_page)
    end

    _invoices
  end

  def to_csv
    ::CSV.generate do |csv|
      csv << ['Invoice #', 'Name', 'Created', 'Status', 'Total']
      invoices(ignore_pagination: true).each do |invoice|
        row = []
        row << invoice.number
        row << invoice.user.name
        row << invoice.created_at.strftime('%m/%-e/%y')
        row << invoice.state.try(:capitalize)
        row << number_to_currency(invoice.price)
        csv << row
      end
    end
  end

  def start_date_friendly
    return nil unless start_date?
    @start_date.to_date
  end

  def end_date_friendly
    return nil unless end_date?
    @end_date.to_date
  end

  private

  def open?
    @status == 'Open'
  end

  def closed?
    @status == 'Closed'
  end

  def query?
    @query.present?
  end

  def start_date?
    @start_date.present?
  end

  def end_date?
    @end_date.present?
  end

  def per_page
    10
  end

end
