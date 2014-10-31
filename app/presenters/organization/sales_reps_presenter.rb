require 'csv'

class Organization::SalesRepsPresenter
  include ActionView::Helpers::TagHelper
  extend Memoist
  attr_reader :organization, :query, :status, :contract, :w8_w9, :page

  def initialize(organization, options)
    @organization = organization
    @query = options[:query]
    @contract = options[:contract]
    @w8_w9 = options[:w8_w9]
    @status = options[:status]
    @page = options[:page]
  end

  def sales_reps(options={})
    _users = User.is_sales_rep.scoped_to(organization.id)
    _users = _users.search(query) if query?
    _users = _users.contract if contract?
    _users = _users.no_contract if no_contract?
    _users = _users.w8 if w8?
    _users = _users.w9 if w9?
    _users = _users.where(w8: false).where(w9: false) if w8_w9_no?
    _users = _users.open if open?
    _users = _users.closed if closed?
    
    if options[:ignore_pagination] == true
      _users = _users.order('users.created_at desc')
    else
      _users = _users.order('users.created_at desc').page(page).per(per_page)
    end

    _users
  end
  memoize :sales_reps

  def to_csv
    ::CSV.generate do |csv|
      csv << ['Member #', 'Name', 'Email', 'Contract', 'W9/W8', 'Status']
      users(ignore_pagination: true).each do |user|
        row = []
        row << user.member_number
        row << user.name
        row << user.email
        row << user.contract? ? 'Yes' : 'No'
        if user.w8?
          row << 'W8'
        elsif user.w9?
          row << 'W9'
        else
          row << 'No'
        end
        row << user.state
        csv << row
      end
    end
  end

  private

  def open?
    @status == 'Open'
  end

  def closed?
    @status == 'Closed'
  end

  def contract?
    @contract == 'Yes'
  end

  def no_contract?
    @contract == 'No'
  end

  def w8?
    @w8_w9 == 'W8'
  end

  def w9?
    @w8_w9 == 'W9'
  end

  def w8_w9_no?
    @w8_w9 == 'No'
  end

  def closed?
    @status == 'Closed'
  end

  def query?
    @query.present?
  end

  def per_page
    20
  end

end
