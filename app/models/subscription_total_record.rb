class SubscriptionTotalRecord < ActiveRecord::Base
  belongs_to :organization
  belongs_to :plan

  scope :between, ->(start_date, end_date) { where(created_at: start_date...end_date)}
end