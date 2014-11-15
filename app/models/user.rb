class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :invitable

  belongs_to :organization
  belongs_to :sales_rep, class_name: 'User'

  has_many :notes
  has_many :subscriptions
  has_many :invoices
  has_many :transactions

  mount_uploader :avatar, AvatarUploader

  store_accessor :billing_info, 
    :card_type, :last_four, :expiration
  
  scope :scoped_to, -> (organization_id) { where("organization_id = ?", organization_id) }
  scope :search, ->(q) { where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ? OR member_number = ?", "%#{q}%", "%#{q}%", "%#{q}%", "#{q.to_i}") }
  scope :between, ->(start_date, end_date) { where(created_at: start_date...end_date) }
  scope :is_sales_rep, -> { where(is_sales_rep: true) }
  scope :open, -> { where(state: :open) }
  scope :closed, -> { where(state: :closed) }
  scope :contract, -> { where(contract: true) }
  scope :no_contract, -> { where(contract: false) }
  scope :w8, -> { where(w8: true) }
  scope :w9, -> { where(w9: true) }
  
  validates :first_name, :last_name, presence: true
  validates :terms_of_service, acceptance: { accept: 'yes' }
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

  def active_subscription_for_product(product)
    subscriptions.active.
      joins("LEFT OUTER JOIN plans on plans.id = subscriptions.plan_id").
      joins("LEFT OUTER JOIN products on products.id = plans.product_id").
      where(["products.id = ?", product.id]).first
  end

  private

  def accepted?
    invitation_token.nil? && invitation_accepted_at.present?
  end

  def invited?
    invitation_accepted_at.nil? && invitation_token.present?
  end
  
end
