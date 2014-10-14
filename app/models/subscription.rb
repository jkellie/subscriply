class Subscription < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  belongs_to :plan
  belongs_to :location

  validates :organization, :plan, presence: true
  validates :location, presence: true, if: :validate_location?

  state_machine initial: :active do
    event :activate do
      transition all => :open
    end
    event :canceling do
      transition :active => :canceling
    end
    event :cancel do
      transition :canceling => :canceled
    end
  end

  private

  def validate_location?
    plan && plan.local_pick_up?
  end
end