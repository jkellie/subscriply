class Api::V1::SubscriptionsController < Api::V1::BaseController
  before_action :find_subscription, only: [:show]
  before_action :find_subscriptions, only: [:index, :active]

  def show
    render json: @subscription
  end

  def index
    render json: @subscriptions
  end

  def active
    render json: @subscriptions.active
  end

  def canceled
    render json: @subscriptions.canceled
  end

  private

  def find_subscription
    @subscription ||= Subscription.find_by(id: params[:id], user_id: current_user.id)
  end

  def find_subscriptions
    @subscriptions ||= Subscription.where(user_id: current_user.id)
  end
end