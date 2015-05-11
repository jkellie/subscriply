class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :email, :authentication_token, :first_name, :last_name,
              :subscriptions, :active_subscriptions

  def subscriptions
    object.subscriptions.map(&:id)
  end

  def active_subscriptions
    object.subscriptions.active.map(&:id)
  end
end