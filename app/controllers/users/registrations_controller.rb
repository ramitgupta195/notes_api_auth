class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # Prevent Devise from using flash (this fixes your test errors)
  def set_flash_message(key, kind, options = {})
    # do nothing
  end

  def set_flash_message!(key, kind, options = {})
    # do nothing
  end

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        message: "Signed up successfully.",
        user: { id: resource.id, email: resource.email, role: resource.role, created_at: resource.created_at }
      }, status: :ok
    else
      render json: { message: "Sign up failed.", errors: resource.errors.full_messages },
             status: :unprocessable_entity
    end
  end
end
