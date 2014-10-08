# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :card_number,
  :client_secret,
  :password,
  :password_confirmation,
  :card_verification
]