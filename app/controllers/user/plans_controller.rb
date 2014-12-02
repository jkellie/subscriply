class User::PlansController < User::BaseController
  include SubdomainHelpers
  respond_to :json

  def show
    respond_with current_organization.plans.find(params[:id])
  end

end
