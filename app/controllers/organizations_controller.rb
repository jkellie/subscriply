class OrganizationsController < Organization::BaseController
  layout 'organizer'

  def new
    @organization = Organization.new
    @organization.organizers.build
    render layout: 'organizer/session'
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save && OrganizationBootstrapper.new(@organization, organizer).run
      flash[:success] = 'Organization Created'
      sign_in_and_redirect(organizer)
    else
      build_error_messages
      flash[:danger] = 'Error Saving Info'
      render 'new', layout: 'organizer/session'
    end
  end

  def edit
    @organization = current_organizer.organization
  end

  def update
    @organization = current_organizer.organization

    if @organization.update_attributes(organization_params)
      flash[:success] = 'Company Info Updated'
      redirect_to organization_dashboard_path
    else
      flash[:danger] = 'Error Saving Info'
      render 'edit'
    end
  end

  private

  def organizer
    @organization.organizers.first
  end

  def build_error_messages
    @errors = @organization.errors.full_messages
    @errors.reject! { |e| e == "Organizers is invalid"}
    @errors.map { |e| e.gsub!('Organizers ', '') if e.include?('Organizers ')}
    @errors.map { |e| e.gsub!("Name can't be blank", "Organization Name can't be blank") if e.include?("Name can't be blank")}
    @errors
  end

  def organization_params
    params.require(:organization).permit(:name, :subdomain, 
      organizers_attributes: organizer_attributes)
  end

  def organizer_attributes
    [:first_name, :last_name, :email, :password, :password_confirmation]
  end

end
