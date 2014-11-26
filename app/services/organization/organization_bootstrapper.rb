class Organization::OrganizationBootstrapper
  attr_reader :organization, :organizer

  def initialize(organization, organizer)
    @organization = organization
    @organizer = organizer
  end

  def run
    set_account_owner
    set_as_super_admin
  end

  private

  def set_account_owner
    organization.update(account_owner_id: organizer.id)
  end

  def set_as_super_admin
    organizer.update_attribute(:super_admin, true)
  end

end