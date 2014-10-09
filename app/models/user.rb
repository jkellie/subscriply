class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :invitable

  belongs_to :organization
  belongs_to :sales_rep, class_name: 'User'

  has_many :notes
  
  scope :scoped_to, -> (organization_id) { where("organization_id = ?", organization_id)}
  scope :search, ->(q) { where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ? OR ID = ?", "%#{q}%", "%#{q}%", "%#{q}%", "#{q.to_i}")}
  scope :between, ->(start_date, end_date) { where(created_at: start_date...end_date)}
  scope :is_sales_rep, -> { where(is_sales_rep: true) }
  scope :open, -> { where(state: :open) }
  scope :closed, -> { where(state: :closed) }
  
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: { scope: :organization }

  state_machine initial: :open do
    event :enable do
      transition :closed => :open
    end
    event :disable do
      transition :open => :closed
    end
  end

  def self.find_for_authentication(warden_conditions)
    where(
      email: warden_conditions[:email],
      organization_id: Organization.find_by_subdomain(warden_conditions[:subdomain]).id
    ).first
  end

  def name
    [first_name, last_name].join ' '
  end

  private

  def accepted?
    invitation_token.nil? && invitation_accepted_at.present?
  end

  def invited?
    invitation_accepted_at.nil? && invitation_token.present?
  end

end
