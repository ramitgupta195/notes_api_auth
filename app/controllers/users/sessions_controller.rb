class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      message: "Logged in successfully.",
      token: request.env["warden-jwt_auth.token"],
      user: {
        id: resource.id,
        email: resource.email,
        role: resource.role,
        created_at: resource.created_at,
        updated_at: resource.updated_at
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: "Logged out successfully." }, status: :ok
    else
      render json: { message: "No active session." }, status: :unauthorized
    end
  end

  # disable flash calls completely
  def set_flash_message!(*args); end
  def set_flash_message(*args); end
end
