class Organization::TransactionsController < Organization::BaseController
  before_action :authenticate_organizer!
  before_action :find_transaction, only: [:show]

  def index
    @transactions_presenter = Organization::TransactionsPresenter.new(
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
        send_data @transactions_presenter.to_csv
      end
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  private

  def find_transaction
    @transaction = Transaction.find(params[:id])
  end

end