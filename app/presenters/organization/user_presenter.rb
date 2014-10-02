class Organization::UserPresenter
  attr_reader :user

  delegate :name, :id, :email, :created_at, :phone_number, to: :user
  delegate :organization, to: :user

  def initialize(user)
    @user = user
  end

  def notes
    user.notes.order('created_at DESC')
  end

  def member_number
    return user.member_number if user.member_number
    'n/a'
  end

end
