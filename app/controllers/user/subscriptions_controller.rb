class User::SubscriptionsController < User::BaseController
  before_action :find_plan, only: :new
  before_action :init_subscription_creator

  def new
  end

  def create
    params[:subscription_wizard][:start_date] = Date.strptime(params[:subscription_wizard][:start_date], '%m/%d/%Y')
    @subscription_wizard.attributes = params[:subscription_wizard]

    if @subscription_creator.create
      flash[:notice] = 'Subscription Created'
      product = @subscription_creator.subscription.product
      redirect_to user_product_path(product)
    else
      flash.now[:danger] = "Error Creating Subscription: #{@subscription_creator.errors_to_sentence}"
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