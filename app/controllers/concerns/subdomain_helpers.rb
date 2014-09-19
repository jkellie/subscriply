module SubdomainHelpers
  extend ActiveSupport::Concern

  def self.included(c)
    c.helper_method :current_organization
    c.helper_method :current_subdomain
  end

  private

  def current_organization
    @current_organization ||= Organization.find_by_subdomain!(request.subdomain) if request.subdomain.present?
  end

  def current_subdomain
    @current_subdomain ||= current_organization.subdomain
  end

end
