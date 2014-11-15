class User::PasswordsController < Devise::PasswordsController
  include SubdomainHelpers
  layout 'user'

end