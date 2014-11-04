class Organization::DashboardController < Organization::BaseController
  before_action :authenticate_organizer!

  def show
    @dashboard_presenter = Organization::DashboardPresenter.new(dashboard_params)
  end

  private

  def dashboard_params
    {
      organization: current_organization,
      plan_id: params[:plan_id],
      start_date: params[:start_date],
      end_date: params[:end_date]
    }
  end

end
