class Invoice < ActiveRecord::Base
  belongs_to :user

  validates :number, uniqueness: { scope: :user_id }

  scope :between, ->(start_date, end_date) { where(created_at: start_date...end_date) }
  scope :search, ->(q) do
    where("invoices.number = ? OR users.first_name ILIKE ? OR users.last_name ILIKE ?",
      "#{q.to_i}", "%#{q}%", "%#{q}%") 
  end

  def price
    self.total_in_cents / 100.0
  end

end