class Api::V1::SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :organization_id, :user_id, :plan_id, :location_id, :state, :next_bill_on, :next_ship_on, :start_date, :canceled_on, :created_at, :updated_at, :uuid, :changing_to

  has_one :plan
  has_one :location
  has_one :product
end