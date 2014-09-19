class Organization::DashboardPresenter
  attr_reader :organizer

  delegate :organization, :first_name, :last_name, to: :organizer

  def initialize(organizer)
    @organizer = organizer
  end

  def organizer_name
    [first_name, last_name].join ' '
  end

  def organizer_avatar
    if organizer.avatar?
      organizer.avatar.url(:thumb)
    else
      'http://placehold.it/50x50'
    end
  end

  def organization_name
    organization.name
  end

end
