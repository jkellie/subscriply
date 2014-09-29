class Organizer < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :invitable

  belongs_to :organization
  
  validates :email, uniqueness: {scope: :organization_id}, presence: true
  validates :password, presence: true, length: {minimum: 5, maximum: 120}, on: :create
  validates :password, length: {minimum: 8, maximum: 120}, on: :update, allow_blank: true
  validates :first_name, :last_name, presence: true, if: :validate_name?

  mount_uploader :avatar, AvatarUploader

  delegate :subdomain, to: :organization

  def name
    [first_name, last_name].join(' ')
  end

  def self.find_for_authentication(warden_conditions)
    where(
      email: warden_conditions[:email],
      organization_id: Organization.find_by_subdomain(warden_conditions[:subdomain]).id
    ).first
  end

  def status
    return 'Owner' if account_owner?
    return 'Accepted' if accepted?
    return 'Invited' if invited?
  end

  def account_owner?
    organization.account_owner == self
  end

  private
  
  def validate_name?
    accepted?
  end

  def accepted?
    invitation_token.nil? && invitation_accepted_at.present?
  end

  def invited?
    invitation_accepted_at.nil? && invitation_token.present?
  end

end
