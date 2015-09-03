class CustomDeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  helper :application
  default template_path: 'devise/mailer'

  def reset_password_instructions(record, token, opts={})
    @token = token
    @subdomain = record.organization.subdomain
    devise_mail(record, :reset_password_instructions, opts)
  end
end
