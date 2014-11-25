class User::SubscriptionsController < User::BaseController
  before_action :find_plan, only: :new

  def new
      
  end

  private

  def find_plan
    @plan = current_organization.plans.find(params[:plan_id])
  end

end