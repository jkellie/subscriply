class SubscriptionTotalRecord < ActiveRecord::Base
  belongs_to :organization
  belongs_to :plan

  scope :between, ->(start_date, end_date) { where(created_at: start_date...end_date)}

  validates :plan_id, uniqueness: {scope: [:organization_id, :created_at]}
end