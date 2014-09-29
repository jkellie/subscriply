class Organization::OrganizersController < Organization::BaseController
  before_action :authenticate_organizer!
  before_action :find_organizers
  before_action :find_organizer, only: [:super_admin_toggle, :destroy]

  def index
  end

  def invite
    @organizer = Organizer.invite!(email: params[:organizer][:email], 
        first_name: params[:organizer][:first_name],
        last_name: params[:organizer][:last_name],
        super_admin: params[:organizer][:super_admin],
        invited_by_id: current_organizer.id, 
        organization_id: current_organization.id)

    if @organizer && @organizer.persisted?
      flash[:notice] = "#{params[:organizer][:first_name]} #{params[:organizer][:last_name]} invited!"
      redirect_to organization_organizers_path
    else
      flash[:error] = "Error inviting organizer"
      render 'index'
    end
  end

  def super_admin_toggle
    if @organizer.toggle(:super_admin) && @organizer.save
      render json: true
    else
      render json: false
    end
  end

  def destroy
    if @organizer.destroy
      render json: true
    end
  end

  private

  def find_organizer
    @organizer = current_organization.organizers.find(params[:id])
  end

  def find_organizers
    @organizers = current_organization.organizers.order('first_name asc, last_name asc').page(page).per(per_page)
  end

  def page
    params[:page] || 1
  end

  def per_page
    10
  end
end