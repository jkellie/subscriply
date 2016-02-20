class Organization::CreditsController < Organization::BaseController
  include ActionView::Helpers::NumberHelper

  before_action :authenticate_organizer!
  before_action :find_user, only: [:new, :create]

  def new
    @user_creditor = Organization::UserCreditor.new(@user)
  end

  def create
    @user_creditor = Organization::UserCreditor.new(@user)
    @user_creditor.attributes = user_creditor_params

    if @user_creditor.create
      flash[:notice] = "Credit Issued for #{number_to_currency(@user_creditor.amount)}"
      redirect_to organization_user_path(@user)
    else
      flash.now[:danger] = "Error Issuing Credit: #{@user_creditor.full_errors}"
      render 'new'
    end
  end

  private

  def find_user
    @user = current_organization.users.find params[:user_id]
  end

  def user_creditor_params
    params.require(:organization_user_creditor).permit(:amount, :description, :accounting_code)
  end
end