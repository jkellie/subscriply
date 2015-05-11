class Api::V1::PlanSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :organization_id, :name, :code, :plan_type, :description, :amount, :charge_every, :free_trial_length, :created_at, :updated_at, :subtitle
end