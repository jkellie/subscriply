begin
  if Rails.env.staging? || Rails.env.production?
    ActionMailer::Base.smtp_settings = {
      :address   => "smtp.mandrillapp.com",
      :port      => 587,
      :enable_starttls_auto => true,
      :user_name => ENV['MANDRILL_USERNAME'],
      :password  => ENV['MANDRILL_API_KEY'],
      :authentication => 'login',
      :domain => 'heroku.com',
    }
    ActionMailer::Base.delivery_method = :smtp
  end
rescue LoadError
  puts "Error configuring mail settings"
  exit(1)
end