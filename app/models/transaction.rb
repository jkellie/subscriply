class Transaction < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :invoice
  belongs_to :user

  validates :uuid, uniqueness: { scope: :user_id }
end