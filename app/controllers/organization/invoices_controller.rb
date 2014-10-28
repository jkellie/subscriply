class Organization::InvoicesController < Organization::BaseController
  before_action :authenticate_organizer!

  def index
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