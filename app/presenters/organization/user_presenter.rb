class Organization::UserPresenter
  attr_reader :user

  delegate :name, :id, :email, :created_at, to: :user
  delegate :organization, to: :user

  def initialize(user)
    @user = user
  end

  def notes
    user.notes.order('created_at DESC')
  end

end
