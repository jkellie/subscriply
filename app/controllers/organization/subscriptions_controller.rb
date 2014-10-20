class Organization::SubscriptionsController < Organization::BaseController
  before_action :authenticate_organizer!

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

  def show
  end

  def edit
  end

  def update
  end

  private

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

  def subscription_params
    params.require(:subscription).permit(:user_id, :plan_id, :location_id).merge(organization_id: current_organization.id)
  end

end