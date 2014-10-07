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
      flash.now[:danger] = 'Error Creating Subscription'
      render 'new'
    end
  end

  def show
    
  end

  def edit
    
  end

  def update
    
  end

end