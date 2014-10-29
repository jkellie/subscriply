class RecurlyController < ApplicationController
  protect_from_forgery except: :recurly_notification

  def recurly_notification
    notification.perform
    render text: 'request accepted'
  end

  private

  def notification
    Billing::NotificationFactory.build_notification(body)
  end

  def body
    if request.body.is_a?(String)
      request.body 
    else
      # for unicorn, since it mucks with request.body
      request.body.read
    end
  end

end