module User::Searchable

  private
  
  def find_users
    @users = current_organization.users
    @users = @users.search(q) if search?
    
    if search_between_dates?
      @users = @users.between(start_date, end_date)
    elsif search_a_date?
      @users = @users.where(["created_at >= ?", start_date]) if start_date?
      @users = @users.where(["created_at <= ?", end_date]) if end_date?
    end

    @users = @users.open if open?
    @users = @users.closed if closed?
    @users = @users.order('created_at DESC').page(page).per(per_page)
  end

  def open?
    params[:state] == 'Open'
  end

  def closed?
    params[:state] == 'Closed'
  end

  def search_between_dates?
    start_date? && end_date?
  end

  def search_a_date?
    start_date? || end_date?
  end

  def start_date
    ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(params[:start_date].to_s).at_beginning_of_day)
  end

  def end_date
    ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(params[:end_date].to_s).at_end_of_day)
  end

  def start_date?
    params[:start_date].present?
  end

  def end_date?
    params[:end_date].present?
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
    10
  end

end