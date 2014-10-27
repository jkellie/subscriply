class RecurlyController < ApplicationController
  protect_from_forgery except: :recurly_notification

  def recurly_notification
    notification.perform
    render text: 'request accepted'
  end

  private

  def notification
    Billing::NotificationFactory.new(body)
  end

  def body
    request.body
  end

end