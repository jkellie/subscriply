class Organization::DashboardPresenter
  attr_reader :organizer

  delegate :organization, :first_name, :last_name, to: :organizer
  delegate :subscriptions, to: :organization

  def initialize(organizer)
    @organizer = organizer
  end

  def total_subscriptions
    rand(1000)
  end

  def new_this_period
    rand(100)    
  end

  def canceled_this_period
    rand(10)
  end

  def sales_this_period
    120000
  end

end
