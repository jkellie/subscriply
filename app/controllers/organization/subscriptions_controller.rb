class Organization::SubscriptionsController < Organization::BaseController
  include Subscription::Searchable

  before_action :authenticate_organizer!
  before_action :find_subscriptions, only: :index
  before_action :find_subscription, only: [:show, :edit, :update, :change_plan, :postpone, :cancel, :canceling, :terminate]

  def index
  end

  def new
    @subscription_creator = Organization::SubscriptionCreator.new(organization: current_organization)
    @sales_reps = current_organization.users.is_sales_rep.order('name ASC')
  end

  def create
    @subscription_creator = Organization::SubscriptionCreator.new(organization: current_organization)
    @subscription_creator.attributes = params[:subscription_creator]

    if @subscription_creator.create
      flash[:notice] = 'Subscription Created'
      redirect_to organization_subscriptions_path
    else
      flash.now[:danger] = "Error Creating Subscription: #{@subscription_creator.errors_to_sentence}"
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
    @subscription = Subscription.new(subscription_params)

    if add_subscription
      flash[:notice] = 'Subscription Created'
      redirect_to organization_user_path(@subscription.user)
    else
      flash[:danger] = "Error Creating Subscription: #{@subscription.errors.full_messages.to_sentence.gsub('base ', '')}"
      redirect_to organization_user_path(@subscription.user)
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
    if update_plan
      flash[:notice] = 'Subscription Updated'
      redirect_to organization_subscription_path(@subscription)
    else
      @subscription_presenter = Organization::SubscriptionPresenter.new(@subscription)
      flash[:danger] = "Error Creating Subscription: #{@subscription.errors.full_messages.to_sentence.gsub('base ', '')}"
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
      flash[:notice] = 'Subscription set to cancel at renewal'
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

  def add_subscription
    begin
      ActiveRecord::Base.transaction do
        @subscription.save
        Billing::Subscription.create(@subscription)
      end
    rescue Exception => e
      @subscription.errors.add(:base, e)
      return false
    end
  end

  def update_plan
    begin
      ActiveRecord::Base.transaction do
        @subscription.update(subscription_params) if apply_immediately?
        Billing::Subscription.update(@subscription.reload, {
          plan_code: new_plan_code, 
          timeframe: timeframe
        })
      end
    rescue Exception => e
      @subscription.errors.add(:base, e)
      return false
    end
  end

  def new_plan_code
    current_organization.plans.find(subscription_params[:plan_id]).permalink
  end

  def timeframe
    subscription_params[:apply_changes]
  end

  def apply_immediately?
    timeframe == 'now'
  end

  def subscription_params
    params.require(:subscription).permit(:user_id, :plan_id, :location_id, :apply_changes).merge(organization_id: current_organization.id)
  end

end