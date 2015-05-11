class Api::V1::UsersController < Api::V1::BaseController  
  def current
    render json: current_user
  end
end