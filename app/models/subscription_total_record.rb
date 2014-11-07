class SubscriptionTotalRecord < ActiveRecord::Base
  belongs_to :organization
  belongs_to :plan
end