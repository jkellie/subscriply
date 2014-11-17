class User::DashboardController < User::BaseController
  # before_action :authenticate_user!
  layout 'splash'

  def show
    render 'splash'
    #@dashboard_presenter = User::DashboardPresenter.new(user: current_user)
  end
end