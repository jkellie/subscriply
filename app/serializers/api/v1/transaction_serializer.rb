class Api::V1::TransactionSerializer < ActiveModel::Serializer
  attributes :id, :subscription_id, :user_id, :invoice_id, :amount_in_cents, :state, :transaction_type, :created_at, :uuid

  has_one :invoice
end