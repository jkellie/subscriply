class User::SubscriptionsController < User::BaseController
  before_action :find_plan, only: :new
  before_action :init_subscription_creator, only: [:new, :create]
  before_action :find_subscription, only: [:edit, :update, :cancel, :reactivate]
  

  def new
  end

  def create
    params[:user_subscription_creator][:start_date] = Date.parse(params[:user_subscription_creator][:start_date])
    @subscription_creator.attributes = params[:user_subscription_creator]

    if @subscription_creator.create
      flash[:notice] = 'Subscription Created'
      product = @subscription_creator.subscription.product
      redirect_to user_product_path(product)
    else
      @plan = current_organization.plans.find(params[:user_subscription_creator][:plan_id])
      flash.now[:danger] = "Error Creating Subscription: #{@subscription_creator.full_errors}"
      render 'new'
    end
  end

  def edit
    @plans = current_organization.plans.where(product_id: @subscription.plan.product_id)
  end

  def update
    subscription_updater = SubscriptionUpdater.new(@subscription)

    if subscription_updater.update({plan_code: new_plan_code, timeframe: 'renewal', plan_id: subscription_params[:plan_id]})
      flash[:notice] = "Subscription Updated. This will take affect at renewal on #{@subscription.next_bill_on.strftime('%m/%d/%Y')}"
      redirect_to user_product_path(@subscription.product)
    else
      flash[:danger] = "Error Updating Subscription: #{subscription_updater.full_errors}"
      redirect_to edit_user_subscription_path(@subscription)
    end
  end

  def cancel
    subscription_canceler = Organization::SubscriptionCanceler.new(@subscription)
    
    if subscription_canceler.cancel
      flash[:notice] = 'Subscription set to cancel at renewal'
      redirect_to root_path
    else
      flash[:danger] = "Error canceling subscription: #{subscription_canceler.full_errors}"
      redirect_to edit_user_subscription_path(@subscription)
    end
  end

  def reactivate
    subscription_reactivator = SubscriptionReactivator.new(@subscription)

    if subscription_reactivator.reactivate
      flash[:notice] = 'Subscription reactivated'
      redirect_to root_path
    else
      flash[:danger] = "Error reactivating subscription: #{subscription_reactivator.full_errors}"
      redirect_to edit_user_subscription_path(@subscription)
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:plan_id)
  end

  def find_plan
    @plan = current_organization.plans.find(params[:plan_id])
  end

  def find_subscription
    @subscription = current_user.subscriptions.find(params[:id])
  end

  def new_plan_code
    current_organization.plans.find(subscription_params[:plan_id]).permalink
  end

  def init_subscription_creator
    @subscription_creator = User::SubscriptionCreator.new(
      organization: current_organization, 
      user: current_user
    )
  end

end