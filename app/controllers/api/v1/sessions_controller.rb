class Api::V1::SessionsController < Devise::SessionsController
  include SubdomainHelpers
  prepend_before_filter :require_no_authentication, :only => [:create ]
  skip_before_action :verify_authenticity_token

  respond_to :json

  def create
    self.resource = warden.authenticate!({scope: :user})
    #sign_in(resource_name, resource, store: false) #store: false
    yield resource if block_given?
    respond_with resource, location: nil
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    respond_to_on_destroy
  end

  def failure
  end

end