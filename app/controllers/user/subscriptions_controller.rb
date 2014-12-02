class User::SubscriptionsController < User::BaseController
  before_action :find_plan, only: :new
  before_action :init_subscription_creator

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

  private

  def find_plan
    @plan = current_organization.plans.find(params[:plan_id])
  end

  def init_subscription_creator
    @subscription_creator = User::SubscriptionCreator.new(
      organization: current_organization, 
      user: current_user
    )
  end

end