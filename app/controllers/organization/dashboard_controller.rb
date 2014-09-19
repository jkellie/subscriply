class Organization::DashboardController < Organization::BaseController
  before_action :authenticate_organizer!

  def show
    @dashboard_presenter = Organization::DashboardPresenter.new(current_organizer)
  end

end
