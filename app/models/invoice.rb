class Invoice < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscription

  validates :number, uniqueness: { scope: :user_id }

  scope :open, -> { where(state: 'open') }
  scope :collected, -> { where(state: 'collected') }
  scope :past_due, -> { where(state: 'past_due') }
  scope :failed, -> { where(state: 'failed') }
  scope :between, ->(start_date, end_date) { where(created_at: start_date...end_date) }
  scope :search, ->(q) do
    where("invoices.number = ? OR users.first_name ILIKE ? OR users.last_name ILIKE ? OR users.id = ?",
      "#{q.to_i}", "%#{q}%", "%#{q}%", "#{q.to_i}") 
  end

  def price
    self.total_in_cents / 100.0
  end

end