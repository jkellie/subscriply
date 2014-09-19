class Organization::InvitationsController < Devise::InvitationsController
  before_filter :update_sanitized_params

  def edit
    render layout: 'session'
  end

  private

  def update_sanitized_params
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:first_name, :last_name, :password, :password_confirmation,
               :invitation_token)
    end
  end

end