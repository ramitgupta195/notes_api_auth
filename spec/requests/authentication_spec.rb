require "rails_helper"

RSpec.describe "Authentication", type: :request do
  let(:user) { create(:user, email: "user@example.com", password: "password123", role: :user) }
  let(:admin) { create(:user, email: "admin@example.com", password: "password123", role: :admin) }
  let(:inactive_user) { create(:user, email: "inactive@example.com", password: "password123", active: false) }

  describe "POST /signup" do
    it "signs up successfully with valid data" do
      post "/signup", params: {
        user: { email: "new@example.com", password: "password123", password_confirmation: "password123" }
      }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Signed up successfully.")
      expect(json["user"]["email"]).to eq("new@example.com")
      expect(json["user"]["role"]).to eq("user") # default role
    end

    it "fails with invalid data" do
      post "/signup", params: {
        user: { email: "", password: "123", password_confirmation: "321" }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Sign up failed.")
      expect(json["errors"]).to be_present
    end
  end

  describe "POST /login" do
    it "logs in as a normal user" do
      post "/login", params: { user: { email: user.email, password: "password123" } }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Logged in successfully.")
      expect(json["token"]).to be_present
      expect(json["user"]["role"]).to eq("user")
    end

    it "logs in as an admin" do
      post "/login", params: { user: { email: admin.email, password: "password123" } }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["user"]["role"]).to eq("admin")
    end

    it "prevents inactive user from logging in" do
      post "/login", params: { user: { email: inactive_user.email, password: "password123" } }

      expect(response).to have_http_status(:unauthorized)
    end

    it "fails with invalid credentials" do
      post "/login", params: { user: { email: user.email, password: "wrong" } }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /logout" do
    it "logs out with a valid JWT" do
      # login first
      post "/login", params: { user: { email: user.email, password: "password123" } }
      token = JSON.parse(response.body)["token"]

      delete "/logout", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Logged out successfully.")
    end

    it "fails to logout without token" do
      delete "/logout"

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["message"]).to eq("No active session.")
    end
  end
end
