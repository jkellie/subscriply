class Organization::PasswordsController < Devise::PasswordsController
  include SubdomainHelpers
  layout 'organizer/session'
end