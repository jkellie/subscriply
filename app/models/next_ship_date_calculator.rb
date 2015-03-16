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

  def base_date
    next_bill_on
  end

  def next_local_pick_up_date
    if base_date.day > 15
      calendar.roll_forward(base_date.at_beginning_of_month + 1.month)
    else
      calendar.roll_forward(base_date.at_beginning_of_month + 15.day)
    end
  end

  def next_ship_date
    calendar.add_business_days(base_date, 1)
  end

  def calendar
    Business::Calendar.new(
      working_days: %w( mon tue wed thu fri )
    )
  end

end
