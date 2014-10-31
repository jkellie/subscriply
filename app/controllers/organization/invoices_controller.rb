class Organization::InvoicesController < Organization::BaseController
  before_action :authenticate_organizer!

  def index
    @invoices_presenter = Organization::InvoicesPresenter.new(
      current_organization,
      query: params[:query],
      start_date: params[:start_date],
      end_date: params[:end_date],
      status: params[:status],
      page: params[:page] || 1
    )
    
    respond_to do |format|
      format.html
      format.js
      format.csv do
        send_data @invoices_presenter.to_csv
      end
    end
  end

  def show
    respond_to do |format|
      format.pdf do
        send_data pdf, content_type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  private

  def pdf
    Billing::Invoice.as_pdf(current_organization, invoice.number)
  end

  def invoice
    current_organization.invoices.find(params[:id])
  end

end