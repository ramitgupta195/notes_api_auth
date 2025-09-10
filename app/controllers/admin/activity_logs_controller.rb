class Admin::ActivityLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    logs = ActivityLog.includes(:user).order(created_at: :desc)
    render json: logs.as_json(include: { user: { only: [ :id, :email ] } })
  end

  private

  def check_admin
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user.admin?
  end
end
