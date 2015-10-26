class ShippingNotificationService

  def start_date
    DateTime.yesterday.at_beginning_of_day
  end

  def end_date
    DateTime.yesterday.at_end_of_day
  end

  def organizations
    Organization.all
  end

  def organization_transactions
    organizations.each do |organization|
      next if organization.shipping_notification_email.blank?

      subscriptions = organization.transactions.between(start_date, end_date).successful.charge.select do |transaction|
        subscription = transaction.subscription
        subscription.plan.shipped?
      end.map {|transaction| transaction.subscription }

      yield organization, subscriptions if block_given?

    end
  end

  def send_notification_email(organization, subscriptions)
    ShippingNotificationMailer.shipping_notification(organization, shipping_notification_csv(subscriptions) ).deliver
  end

  def run
    organization_transactions do |organization, subscriptions|
      send_notification_email(organization, subscriptions) if subscriptions.any?
    end
  end

  def self.run
    self.new.run
  end

  private

  def shipping_notification_csv(subscriptions)
    Reports::CSV::ShippingNotificationReport.to_csv(subscriptions)
  end
end