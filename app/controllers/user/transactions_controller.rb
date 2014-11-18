class User::TransactionsController < User::BaseController
  before_action :authenticate_user!

  def index
    @transactions = current_user.transactions.order('created_at DESC').page(page).per(per_page)
  end

  private

  def page
    params[:page] || 1
  end

  def per_page
    20
  end
end