class User::DashboardPresenter
  attr_reader :user
  delegate :subscriptions, to: :user

  def initialize(options)
    @user = options[:user]
  end

end
