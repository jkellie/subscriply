class Subscription < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  belongs_to :plan
end