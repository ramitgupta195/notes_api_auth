class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: current_user
  end

  def update
    if current_user.update(profile_params)
      render json: current_user
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
