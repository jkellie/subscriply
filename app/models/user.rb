class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :invitable

  belongs_to :organization
  
  scope :scoped_to, -> (organization_id) { where("organization_id = ?", organization_id)}
  
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: { scope: :organization }

  def self.find_for_authentication(warden_conditions)
    where(
      email: warden_conditions[:email],
      organization_id: Organization.find_by_subdomain(warden_conditions[:subdomain]).id
    ).first
  end

  def name
    [first_name, last_name].join ' '
  end

end
