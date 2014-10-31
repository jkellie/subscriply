class Organization::SalesRepsController < Organization::BaseController
  before_action :authenticate_organizer!

  def index
    @sales_reps_presenter = Organization::SalesRepsPresenter.new(
      current_organization,
      query: params[:query],
      contract: params[:contract],
      w8_w9: params[:w8_w9],
      status: params[:status],
      page: params[:page] || 1)
    
    respond_to do |format|
      format.html
      format.js
      format.csv do
        send_data @sales_reps_presenter.to_csv
      end
    end
  end


end