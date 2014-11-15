class User::DashboardController < User::BaseController
  before_action :authenticate_user!

  def show
    @dashboard_presenter = User::DashboardPresenter.new(user: current_user)
  end
end