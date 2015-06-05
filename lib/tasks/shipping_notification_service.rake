namespace :shipping_notification_service do
  task :run => :environment do
    puts "Sending Shipping Notification Emails"
    ShippingNotificationService.run
  end
end