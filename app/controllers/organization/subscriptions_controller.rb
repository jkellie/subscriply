class Organization::SubscriptionsController < Organization::BaseController
  include Subscription::Searchable

  before_action :authenticate_organizer!
  before_action :find_subscriptions, only: :index
  before_action :find_subscription, only: [:show, :edit, :update, :change_plan, :postpone, :cancel, :canceling, :terminate]

  def index
  end

  def new
    @subscription_wizard = Organization::SubscriptionWizard.new(organization: current_organization)
    @sales_reps = current_organization.users.is_sales_rep.order('name ASC')
  end

  def create
    @subscription_wizard = Organization::SubscriptionWizard.new(organization: current_organization)
    params[:subscription_wizard][:start_date] = Date.strptime(params[:subscription_wizard][:start_date], '%m/%d/%Y')
    @subscription_wizard.attributes = params[:subscription_wizard]

    if @subscription_wizard.create
      flash[:notice] = 'Subscription Created'
      redirect_to organization_subscriptions_path
    else
      flash.now[:danger] = "Error Creating Subscription: #{@subscription_wizard.errors_to_sentence}"
      render 'new'
    end
  end

  def show
    @subscription_presenter = Organization::SubscriptionPresenter.new(@subscription)
  end

  def edit
    @subscription_presenter = Organization::SubscriptionPresenter.new(@subscription)
    @plans = current_organization.plans.where(product_id: @subscription.plan.product_id)
  end

  def add
    subscription_creator = SubscriptionCreator.new(subscription_params)

    if subscription_creator.create
      flash[:notice] = 'Subscription Created'
      redirect_to organization_user_path(subscription_creator.user)
    else
      flash[:danger] = "Error Creating Subscription: #{subscription_creator.full_errors}"
      redirect_to organization_user_path(subscription_creator.user)
    end
  end

  #changing locations
  def update
    if @subscription.update(subscription_params)
      flash[:notice] = 'Subscription Updated'
      redirect_to organization_subscription_path(@subscription)
    else
      @subscription_presenter = Organization::SubscriptionPresenter.new(@subscription)
      @plans = current_organization.plans.where(product_id: @subscription.plan.product_id)
      flash.now[:danger] = 'Error Updating Subscription: #{@subscription.errors.full_messages.to_sentence'
      render 'edit'
    end
  end

  def change_plan
    subscription_updater = SubscriptionUpdater.new(@subscription)

    if subscription_updater.update({plan_code: new_plan_code, timeframe: subscription_params[:apply_changes], plan_id: subscription_params[:plan_id]})
      flash[:notice] = 'Subscription Updated'
      redirect_to organization_subscription_path(@subscription)
    else
      flash[:danger] = "Error Updating Subscription: #{subscription_updater.full_errors}"
      redirect_to edit_organization_subscription_path(@subscription)
    end
  end

  def postpone
    subscription_postponer = SubscriptionPostponer.new(@subscription)
    
    if subscription_postponer.postpone(params[:renewal_date])
      flash[:notice] = "Subscription renewal date is now #{@subscription.reload.next_bill_on.strftime('%m/%-e/%y')}"
    else
      flash[:danger] = "Error postponing subscription: #{subscription_postponer.full_errors}"
    end
    redirect_to organization_subscription_path(@subscription)
  end  

  def canceling
    @subscription_presenter = Organization::SubscriptionPresenter.new(@subscription)
  end

  def cancel
    subscription_canceler = SubscriptionCanceler.new(@subscription)
    
    if subscription_canceler.cancel
      flash[:notice] = 'Subscription set to cancel at renewal'
      redirect_to organization_subscription_path(@subscription)
    else
      flash[:danger] = "Error canceling subscription: #{subscription_canceler.full_errors}"
      redirect_to canceling_organization_subscription_path(@subscription)
    end
  end

  def terminate
    subscription_terminator = SubscriptionTerminator.new(@subscription)

    if subscription_terminator.terminate(params[:refund_type])
      flash[:notice] = "Subscription terminated and refund set to #{params[:refund_type]}"
      redirect_to organization_subscription_path(@subscription)
    else
      flash[:danger] = "Error canceling subscription: #{subscription_terminator.full_errors}"
      redirect_to canceling_organization_subscription_path(@subscription)
    end
  end

  private

  def find_subscription
    @subscription = current_organization.subscriptions.find params[:id]
  end

  def new_plan_code
    current_organization.plans.find(subscription_params[:plan_id]).permalink
  end

  def subscription_params
    params.require(:subscription).permit(:user_id, :plan_id, :location_id, :apply_changes, :start_date).merge(organization_id: current_organization.id)
  end

end