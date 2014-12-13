class Subscription < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  belongs_to :plan
  has_one :product, through: :plan
  belongs_to :location
  has_many :transactions

  attr_accessor :product_id, :apply_changes

  validates :organization, :plan, presence: true
  validates :location, presence: true, if: :validate_location?

  scope :search, ->(q) do
    joins("LEFT OUTER JOIN plans on plans.id = subscriptions.plan_id").
    joins("LEFT OUTER JOIN users on users.id = subscriptions.user_id").
    where("users.first_name ILIKE ? OR users.last_name ILIKE ? OR plans.name ILIKE ? OR users.member_number = ?", 
      "%#{q}%", "%#{q}%", "%#{q}%", "#{q.to_i}")
  end

  scope :between, ->(start_date, end_date) { where(start_date: start_date...end_date)}
  scope :canceled_between, ->(start_date, end_date) { where(canceled_on: start_date...end_date)}
  scope :invoice_between, ->(start_date, end_date) { where(next_bill_on: start_date...end_date)}
  scope :future, -> { where(state: :future) }
  scope :active, -> { where(state: :active) }
  scope :canceling, -> { where(state: :canceling) }
  scope :canceled, -> { where(state: :canceled) }

  state_machine initial: :active do
    event :activate do
      transition all => :active
    end
    event :canceling do
      transition :active => :canceling
    end
    event :cancel do
      transition all => :canceled
    end
    state :future
  end

  def editable?
    active?
  end

  def changing?
    changing_to.present?
  end

  private

  def validate_location?
    plan && plan.local_pick_up?
  end
end