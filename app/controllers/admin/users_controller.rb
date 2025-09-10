class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_user, only: [ :destroy, :update ]

  def index
    users = User.includes(:notes).all
    render json: users.as_json(
      include: { notes: { only: [ :id, :title, :content ] } },
      only: [ :id, :email, :role ]
    )
  end

  def destroy
    if @user.deactivate!
      render json: { message: "User deactivated successfully" }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(role: params[:role])
      render json: { message: "User role updated successfully." }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def check_admin
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user.admin?
  end
end
