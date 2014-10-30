require 'csv'

class Organization::UsersPresenter
  include ActionView::Helpers::TagHelper
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

  def users(options={})
    _users = User.scoped_to(organization.id)
    _users = _users.search(query) if query?
    _users = _users.open if open?
    _users = _users.closed if closed?

    if start_date? && end_date?
      _users = _users.between(start_date, end_date)
    elsif start_date? || end_date?
      _users = _users.where(["users.created_at >= ?", start_date]) if start_date?
      _users = _users.where(["users.created_at <= ?", end_date]) if end_date?
    else
      _users = _users
    end
    
    if options[:ignore_pagination] == true
      _users = _users.order('users.created_at desc')
    else
      _users = _users.order('users.created_at desc').page(page).per(per_page)
    end

    _users
  end
  memoize :users

  def to_csv
    ::CSV.generate do |csv|
      csv << ['Member #', 'Name', 'Email', 'Created', 'Status']
      users(ignore_pagination: true).each do |user|
        row = []
        row << user.member_number
        row << user.name
        row << user.email
        row << user.created_at.strftime('%m/%-e/%y')
        row << user.state
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
