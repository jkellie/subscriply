class Api::V1::ProductSerializer < ActiveModel::Serializer
  attributes :id, :organization_id, :name, :prepend_code, :description, :image, :created_at, :updated_at
end