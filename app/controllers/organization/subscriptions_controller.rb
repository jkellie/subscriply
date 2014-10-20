class Organization::SubscriptionsController < Organization::BaseController
  before_action :authenticate_organizer!
  before_action :find_subscriptions, only: :index

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
    subscription = current_organization.subscriptions.find(params[:id])
    @subscription_presenter = Organization::SubscriptionPresenter.new(subscription)
  end

  def edit
  end

  def update
  end

  private

  def find_subscriptions
    @subscriptions = current_organization.subscriptions

    @subscriptions = @subscriptions.search(q) if search?
    
    if search_between_invoice_dates?
      @subscriptions = @subscriptions.invoice_between(invoice_start_date, invoice_end_date)
    elsif search_a_invoice_date?
      @subscriptions = @subscriptions.where(["next_bill_on >= ?", invoice_start_date]) if invoice_start_date?
      @subscriptions = @subscriptions.where(["next_bill_on <= ?", invoice_end_date]) if invoice_end_date?
    end

    @subscriptions = @subscriptions.active if active?
    @subscriptions = @subscriptions.canceled if canceled?
    @subscriptions = @subscriptions.canceling if canceling?

    @subscriptions = @subscriptions.order('created_at DESC').page(page).per(per_page)
  end

  def active?
    params[:state] == 'Active'
  end

  def canceling?
    params[:state] == 'Canceling'
  end

  def canceled?
    params[:state] == 'Canceled'
  end

  def q
    params[:q]
  end

  def search?
    q.present?
  end

  def page
    params[:page] || 1
  end

  def per_page
    20
  end

  def search_between_invoice_dates?
    invoice_start_date? && invoice_end_date?
  end

  def search_a_invoice_date?
    invoice_start_date? || invoice_end_date?
  end

  def invoice_start_date
    ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(params[:invoice_start_date].to_s).at_beginning_of_day)
  end

  def invoice_end_date
    ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(params[:invoice_end_date].to_s).at_end_of_day)
  end

  def invoice_start_date?
    params[:invoice_start_date].present?
  end

  def invoice_end_date?
    params[:invoice_end_date].present?
  end

  def add_subscription
    begin
      ActiveRecord::Base.transaction do
        @subscription.save
        billing_subscription = Billing::Subscription.create(@subscription)
        @subscription.update_attributes({
          uuid: billing_subscription.uuid,
          state: billing_subscription.state,
          next_bill_on: billing_subscription.current_period_ends_at,
          start_date: billing_subscription.activated_at
        })
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