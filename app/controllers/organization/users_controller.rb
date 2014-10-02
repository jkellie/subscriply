class Organization::UsersController < Organization::BaseController
  before_action :authenticate_organizer!
  before_action :find_users, only: :index

  respond_to :html, :json

  def index
  end

  def new
  end

  def create
    @user = User.invite!(user_invite_params)

    if @user && @user.persisted?
      flash[:notice] = "#{params[:user][:first_name]} #{params[:user][:last_name]} invited!"
      redirect_to organization_users_path
    else
      flash[:error] = "Error inviting organizer"
      render 'new'
    end
  end

  def show
    @user_presenter = Organization::UserPresenter.new(User.find(params[:id]))
    @note = Note.new(user: @user_presenter.user)
  end

  def edit
    @user = current_organization.users.find(params[:id])
  end

  def update
    @user = current_organization.users.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:notice] = 'User Info Saved!'
      redirect_to organization_user_path(@user)
    else
      flash.now[:error] = 'Error updating user'
      render 'show'
    end
  end

  def search_by_email
    respond_to do |format|
      format.json do
        if @user = User.scoped_to(current_organization.id).find_by_email(params[:email])
          respond_with @user
        else
          render json: { error: 'User not found' }, status: 422
        end
      end
    end
  end

  private

  def find_users
    @users = current_organization.users
    @users = @users.search(q) if search?
    
    if search_between_dates?
      @users = @users.between(start_date, end_date)
    elsif search_a_date?
      @users = @users.where(["created_at >= ?", start_date]) if start_date?
      @users = @users.where(["created_at <= ?", end_date]) if end_date?
    end

    @users = @users.page(page).per(per_page)
  end

  def search_between_dates?
    start_date? && end_date?
  end

  def search_a_date?
    start_date? || end_date?
  end

  def start_date
    ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(params[:start_date].to_s).at_beginning_of_day)
  end

  def end_date
    ActiveSupport::TimeWithZone.new(nil, Time.zone, DateTime.parse(params[:end_date].to_s).at_end_of_day)
  end

  def start_date?
    params[:start_date].present?
  end

  def end_date?
    params[:end_date].present?
  end

  def user_invite_params
    params.require(:user).permit(:first_name, :last_name, :email, :sales_rep).merge(invited_by_id: current_organizer.id, 
        organization_id: current_organization.id)
  end

  def user_params
    params.require(:user).permit([])
  end

  def q
    params[:q]
  end

  def search?
    q.present?
  end

  def page
    params[:page] || 1
  end

  def per_page
    10
  end
end