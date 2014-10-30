class Transaction < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :invoice
  belongs_to :user

  validates :uuid, uniqueness: { scope: :user_id }

  def price
    self.amount_in_cents / 100.0
  end

  def charge?
    self.transaction_type == 'charge'
  end

  def refund?
    self.transaction_type == 'refund'
  end

end