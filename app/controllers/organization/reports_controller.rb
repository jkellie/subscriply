class Organization::ReportsController < Organization::BaseController
  respond_to :csv, :html, :js
  before_action :authenticate_organizer!
  before_action :find_presenter

  private

  def find_presenter
    @report_presenter = Organization::ReportPresenter.new(presenter_params)

    respond_with @report_presenter
  end
  
  def presenter_params
    {
      organization: current_organization,
      plan_id: params[:plan_id],
      plan_type: plan_type,
      location_id: params[:location_id],
      start_date: params[:start_date],
      end_date: params[:end_date]
    }
  end

  def plan_type
    {
      'digital_membership' => 'digital', 
      'direct_shipping' => 'shipped', 
      'local_pickup' => 'local_pick_up'}[action_name]
  end

end