class Api::V1::TransactionsController < Api::V1::BaseController
  before_action :find_transactions, only: [:index, :successful, :failed]

  def index
    render json: @transactions
  end

  def successful
    @transactions = @transactions.successful.charge
    render json: @transactions
  end

  def failed
    @transactions = @transactions.declined.charge
    render json: @transactions
  end

  def show
    render json: @transaction
  end

  private 

  def find_transaction
    @transaction = Transaction.find_by(
      subscription_id: params[:subscription_id], 
      user_id: current_user.id,
      id: params[:id])
  end

  def find_transactions
    @transactions ||= Transaction.where(
      subscription_id: params[:subscription_id], 
      user_id: current_user.id)
  end
end