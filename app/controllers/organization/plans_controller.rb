class Organization::PlansController < Organization::BaseController

  def index
    @plans = current_organization.plans.order('created_at ASC')
  end

  def edit
    @plan = current_organization.plans.find(params[:id])
    @products = current_organization.products.order('name ASC')
  end

  def new
    @plan = Plan.new
    @products = current_organization.products.order('name ASC')
  end

  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      flash[:info] = 'Plan created'
      redirect_to organization_plans_path
    else
      flash.now[:danger] = 'Error Creating Plan'
      render 'new'
    end
  end

  def update
    @plan = current_organization.plans.find(params[:id])

    if @plan.update(plan_params)
      flash[:info] = 'Plan updated'
      redirect_to organization_plans_path
    else
      flash.now[:danger] = 'Error Updating Plan'
      render 'edit'
    end
  end

  def destroy
    @plan = current_organization.plans.find(params[:id])

    if @plan.destroy
      flash[:info] = 'Plan Destroyed'
    else
      flash[:danger] = 'Error Destroying Plan'
    end

    redirect_to organization_plans_path
  end

  private

  def plan_params
    binding.pry_remote
    params.require(:plan).permit(:name, :product_id, :code, :plan_type, :description, 
      :send_renewal_reminders, :amount, :charge_every, :free_trial_length).merge(organization_id: current_organization.id)
  end
end
