class ShippingNotificationMailer < ActionMailer::Base
  default from: "notifications@subscriply.com"

  def shipping_notification(organization, subscriptions_csv)
    attachments['subscriptions.csv'] = {mime_type: 'text/csv',content: subscriptions_csv} if subscriptions_csv
    mail(to: organization.shipping_notification_email, subject: 'Shipping Notification')
  end
end
