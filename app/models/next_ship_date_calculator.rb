class NextShipDateCalculator
  attr_reader :subscription
  delegate :plan, :next_bill_on, to: :subscription
  
  def initialize(subscription) 
    @subscription = subscription
  end

  def calculate
    if plan.local_pick_up?
      next_local_pick_up_date
    else
      next_ship_date
    end
  end

  private

  def next_local_pick_up_date
    target_date = next_bill_on.at_beginning_of_month + 15
    
    if target_date > next_bill_on
      calendar.roll_forward(target_date)
    else
      calendar.roll_forward(next_bill_on.at_beginning_of_month.next_month)
    end    
  end

  def next_ship_date
    calendar.add_business_days(next_bill_on, 1)
  end

  def calendar
    Business::Calendar.new(
      working_days: %w( mon tue wed thu fri )
    )
  end

end
