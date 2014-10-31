module Billing
  class Notification::NullNotification
    
    def perform
      true
    end
    
  end
end