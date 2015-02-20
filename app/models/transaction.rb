class Transaction < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :invoice
  belongs_to :user

  validates :uuid, uniqueness: { scope: :user_id }

  scope :between, ->(start_date, end_date) { where(created_at: start_date...end_date)}
  scope :charge, -> { where(transaction_type: 'charge') }
  scope :refund, -> { where(transaction_type: 'refund') }
  scope :successful, -> { where(state: 'success') }
  scope :declined, -> { where(state: 'declined') }
  scope :void, -> { where(state: 'void') }
  scope :search, -> (q) do
    joins( :user, subscription: :plan).
    where("plans.name ILIKE ? OR users.first_name ILIKE ? OR users.last_name ILIKE ? OR users.member_number = ? OR users.id = ?",
      "%#{q}%", "%#{q}%", "%#{q}%", "#{q.to_i}", "#{q.to_i}") 
  end
  scope :by_plan, -> (plan_id) do
    joins(subscription: :plan).where(plans: { id: plan_id})
  end

  def price
    self.amount_in_cents / 100.0
  end

  def charge?
    self.transaction_type == 'charge'
  end

  def refund?
    self.transaction_type == 'refund'
  end

  def success?
    self.state == 'success'
  end

end