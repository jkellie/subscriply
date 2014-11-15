class User::DashboardController < User::BaseController
  def show
    @dashboard_presenter = User::DashboardPresenter.new(user: current_user)
  end
end