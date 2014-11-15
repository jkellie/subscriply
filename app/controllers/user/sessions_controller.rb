class User::SessionsController < Devise::SessionsController
  include SubdomainHelpers
  layout 'user'

end