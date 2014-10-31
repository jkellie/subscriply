require 'csv'

class Organization::TransactionsPresenter
  include ActionView::Helpers::NumberHelper
  extend Memoist
  attr_reader :organization, :query, :start_date, :end_date, :status, :page

  def initialize(organization, options)
    @organization = organization
    @query = options[:query]
    @start_date = ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(options[:start_date].to_s).at_beginning_of_day) if options[:start_date].present?
    @end_date = ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(options[:end_date].to_s).at_end_of_day) if options[:end_date].present?
    @status = options[:status]
    @page = options[:page]
  end

  def transactions(options={})
    _transactions = organization.transactions
    _transactions = _transactions.search(query) if query?
    _transactions = _transactions.successful if successful?
    _transactions = _transactions.declined if declined?
    _transactions = _transactions.void if void?

    if start_date? && end_date?
      _transactions = _transactions.between(start_date, end_date)
    elsif start_date? || end_date?
      _transactions = _transactions.where(["transactions.created_at >= ?", start_date]) if start_date?
      _transactions = _transactions.where(["transactions.created_at <= ?", end_date]) if end_date?
    else
      _transactions = _transactions
    end
    
    if options[:ignore_pagination] == true
      _transactions = _transactions.order('transactions.created_at desc')
    else
      _transactions = _transactions.order('transactions.created_at desc').page(page).per(per_page)
    end

    _transactions
  end
  memoize :transactions

  def to_csv
    ::CSV.generate do |csv|
      csv << ['Type', 'Description', 'Created', 'Amount', 'Status']
      transactions(ignore_pagination: true).each do |transaction|
        row = []
        row << transaction.transaction_type
        if transaction.charge?
          row << transaction.subscription.plan
        elsif transaction.credit?
          row << ' - '
        end
        row << transaction.created_at.strftime('%m/%-e/%y')
        row << number_to_currency(transaction.price)
        row << transaction.state.try(:capitalize)
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

  def successful?
    @status == 'Successful'
  end

  def declined?
    @status == 'Declined'
  end

  def void?
    @status == 'Void'
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
    20
  end

end
