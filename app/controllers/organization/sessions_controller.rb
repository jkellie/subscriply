class Organization::SessionsController < Devise::SessionsController
  layout 'organizer/session'

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
