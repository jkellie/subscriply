namespace :subscription_total_recorder do
  task :run => :environment do
    puts "Creating Subscription Totals"
    SubscriptionTotalRecorder.run
  end
end