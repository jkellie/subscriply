class Subscription < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  belongs_to :plan
  belongs_to :location

  validates :organization, :plan, presence: true
  validates :location, presence: true, if: :validate_location?

  private

  def validate_location?
    plan && plan.local_pick_up?
  end
end