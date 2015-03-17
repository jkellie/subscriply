module ApplicationHelper

  def current_step(step)
    content_for("current_step_#{step.parameterize}", 1)
  end

  def current_step?(step)
    content_for?("current_step_#{step.parameterize}")
  end

  def current_nav(nav)
    content_for("current_nav#{nav}", 1)
  end

  def current_nav?(nav)
    content_for?("current_nav#{nav}")
  end

  def timepicker_collection
    ['7:00 AM', '7:15 AM', '7:30 AM', '7:45 AM',
     '8:00 AM', '8:15 AM', '8:30 AM', '8:45 AM',
     '9:00 AM', '9:15 AM', '9:30 AM', '9:45 AM',
     '10:00 AM', '10:15 AM', '10:30 AM', '10:45 AM',
     '11:00 AM', '11:15 AM', '11:30 AM', '11:45 AM',
     '12:00 PM', '12:15 PM', '12:30 PM', '12:45 PM',
     '1:00 PM', '1:15 PM', '1:30 PM', '1:45 PM',
     '2:00 PM', '2:15 PM', '2:30 PM', '2:45 PM',
     '3:00 PM', '3:15 PM', '3:30 PM', '3:45 PM',
     '4:00 PM', '4:15 PM', '4:30 PM', '4:45 PM',
     '5:00 PM', '5:15 PM', '5:30 PM', '5:45 PM',
     '6:00 PM', '6:15 PM', '6:30 PM', '6:45 PM',
     '7:00 PM', '7:15 PM', '7:30 PM', '7:45 PM',
     '8:00 PM', '8:15 PM', '8:30 PM', '8:45 PM',
     '9:00 PM', '9:15 PM', '9:30 PM', '9:45 PM',
    ]
  end

  def months_for_select
    [['January', 1], ['February', 2], ['March', 3], ['April', 4], ['May', 5],
     ['June', 6], ['July', 7], ['August', 8], ['September', 9], ['October', 10],
     ['November', 11], ['December', 12]]
  end

  def years_for_select
    ([]).tap do |years|
      (0..15).each do |i|
        years << Date.today.year + i
      end
    end
  end

  def us_states
    [
      ['AK', 'AK'],
      ['AL', 'AL'],
      ['AR', 'AR'],
      ['AZ', 'AZ'],
      ['CA', 'CA'],
      ['CO', 'CO'],
      ['CT', 'CT'],
      ['DC', 'DC'],
      ['DE', 'DE'],
      ['FL', 'FL'],
      ['GA', 'GA'],
      ['HI', 'HI'],
      ['IA', 'IA'],
      ['ID', 'ID'],
      ['IL', 'IL'],
      ['IN', 'IN'],
      ['KS', 'KS'],
      ['KY', 'KY'],
      ['LA', 'LA'],
      ['MA', 'MA'],
      ['MD', 'MD'],
      ['ME', 'ME'],
      ['MI', 'MI'],
      ['MN', 'MN'],
      ['MO', 'MO'],
      ['MS', 'MS'],
      ['MT', 'MT'],
      ['NC', 'NC'],
      ['ND', 'ND'],
      ['NE', 'NE'],
      ['NH', 'NH'],
      ['NJ', 'NJ'],
      ['NM', 'NM'],
      ['NV', 'NV'],
      ['NY', 'NY'],
      ['OH', 'OH'],
      ['OK', 'OK'],
      ['OR', 'OR'],
      ['PA', 'PA'],
      ['PR', 'PR'],
      ['RI', 'RI'],
      ['SC', 'SC'],
      ['SD', 'SD'],
      ['TN', 'TN'],
      ['TX', 'TX'],
      ['UT', 'UT'],
      ['VA', 'VA'],
      ['VT', 'VT'],
      ['WA', 'WA'],
      ['WI', 'WI'],
      ['WV', 'WV'],
      ['WY', 'WY']
    ]
  end

  def plans_for_select(plan)
    Plan.where(product_id: plan.product_id).order('amount asc').map { |p| ["#{p} - #{number_to_currency(p.amount)}", p.id]}
  end
end
