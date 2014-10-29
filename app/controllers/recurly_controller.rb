class RecurlyController < ApplicationController
  protect_from_forgery except: :recurly_notification

  def recurly_notification
    puts "request body is: #{request.body.to_s}"
    Rails.logger.debug "request body is #{request.body.to_s}
    notification.perform
    render text: 'request accepted'
  end

  private

  def notification
    Billing::NotificationFactory.build_notification(body)
  end

  def body
    request.body
  end

end