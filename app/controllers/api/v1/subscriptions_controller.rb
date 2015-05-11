class Api::V1::SubscriptionsController < Api::V1::BaseController
  def show
    render json: find_subscription
  end

  private

  def find_subscription
    @subscription = Subscription.find_by(id: params[:id], user_id: current_user.id)
  end
end