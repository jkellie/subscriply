class Invoice < ActiveRecord::Base
  belongs_to :user

  validates :number, uniqueness: { scope: :user_id }

  def price
    self.total_in_cents / 100.0
  end

end