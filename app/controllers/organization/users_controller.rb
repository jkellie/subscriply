class Organization::UsersController < Organization::BaseController
  include User::Searchable

  before_action :authenticate_organizer!
  before_action :find_users, only: :index

  respond_to :html, :json

  def index
  end

  def new
    @sales_reps = current_organization.users.is_sales_rep.order('first_name ASC')
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
    @sales_reps = current_organization.users.is_sales_rep.order('first_name ASC')
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

  def edit_billing_info
    @user = current_organization.users.find(params[:id])
  end

  def update_billing_info
    @user = current_organization.users.find(params[:id])

    if update_remote_and_cached_billing_info(@user, params[:recurly_token])
      flash[:notice] = 'Billing Info Saved!'
      redirect_to organization_user_path(@user)
    else
      flash.now[:error] = 'Error updating billing info'
      render 'edit_billing_info'
    end
  end

  private

  def update_remote_and_cached_billing_info(user, token)
    Billing::User.update_billing_info(user, token) && Billing::User.update_cached_billing_info(user)
  end

  def user_invite_params
    params.require(:user).permit(:first_name, :last_name, :email, :is_sales_rep, :sales_rep_id).merge(invited_by_id: current_organizer.id, 
        organization_id: current_organization.id)
  end

  def user_params
    params.require(:user).permit([:member_number, :sales_rep_id, :first_name, :last_name, 
      :email, :sales_rep, :phone_number, :contract, :w8, :w9, :street_address, :street_address_2,
      :city, :state_code, :zip])
  end

end