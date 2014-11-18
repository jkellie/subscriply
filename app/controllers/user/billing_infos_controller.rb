class User::BillingInfosController < User::BaseController
  before_action :authenticate_user!

  def edit

  end

  def update
    @billing_info_updater = UserBillingInfoUpdater.new(current_user)
    
    if @billing_info_updater.update(params[:recurly_token])
      flash[:notice] = 'Billing Info Updated!'
      redirect_to edit_user_billing_info_path
    else
      flash.now[:error] = 'Error updating billing info'
      render 'edit'
    end
  end

end