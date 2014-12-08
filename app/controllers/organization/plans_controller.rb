class Organization::PlansController < Organization::BaseController
  before_action :require_recurly
  before_action :find_plans, only: [:index]
  before_action :find_plan, only: [:edit, :update, :destroy]
  before_action :find_products, only: [:edit, :new, :create, :update]

  respond_to :html, :json

  def index
    respond_to do |format|
      format.html
      format.json do
        respond_with @plans
      end
    end
  end

  def edit
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)

    if @plan.save && @plan.create_on_recurly
      flash[:info] = 'Plan created'
      redirect_to organization_plans_path
    else
      flash.now[:danger] = "Error Creating Plan: #{@plan.errors.full_messages.to_sentence}"
      render 'new'
    end
  end

  def update
    if @plan.update(plan_params) && @plan.update_on_recurly
      flash[:info] = 'Plan updated'
      redirect_to organization_plans_path
    else
      flash.now[:danger] = "Error Creating Plan: #{@plan.errors.full_messages.to_sentence}"
      render 'edit'
    end
  rescue Recurly::Resource::NotFound
    flash.now[:danger] = 'Error Finding Plan on Recurly. Please email support for assistance'
    render 'edit'
  end

  def destroy
    if @plan.destroy
      flash[:info] = 'Plan Destroyed'
    else
      flash[:danger] = 'Error Destroying Plan'
    end

    redirect_to organization_plans_path
  end

  private

  def find_plans
    @plans = current_organization.plans
    @plans = @plans.where(product_id: params[:product_id]) if params[:product_id].present?
    @plans = @plans.order('created_at ASC')
  end

  def find_plan
    @plan = current_organization.plans.find(params[:id])
  end

  def find_products
    @products = current_organization.products.order('name ASC')
  end

  def plan_params
    params.require(:plan).permit(:name, :product_id, :code, :plan_type, :description, 
      :send_renewal_reminders, :amount, :charge_every, :free_trial_length, :subtitle,
      bulletpoints_attributes: [:id, :icon, :title, :_destroy]).merge(organization_id: current_organization.id)
  end
end
