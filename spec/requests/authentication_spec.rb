require "rails_helper"

RSpec.describe "Authentication", type: :request do
  let(:user) { create(:user, email: "test@example.com", password: "password123") }

  describe "POST /signup" do
    it "creates a new user" do
      post "/signup", params: {
        user: { email: "newuser@example.com", password: "password123", password_confirmation: "password123" }
      }

      expect(response).to have_http_status(:ok).or have_http_status(:created)
      expect(JSON.parse(response.body)["user"]["email"]).to eq("newuser@example.com")
    end
  end

  describe "POST /login" do
    it "logs in with valid credentials and returns a JWT token" do
      post "/login", params: {
        user: { email: user.email, password: "password123" }
      }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["token"]).to be_present
      expect(json["user"]["email"]).to eq(user.email)
    end

    it "fails with invalid credentials" do
      post "/login", params: {
        user: { email: user.email, password: "wrongpassword" }
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /logout" do
    it "logs out successfully with valid JWT" do
      # login first
      post "/login", params: {
        user: { email: user.email, password: "password123" }
      }
      token = JSON.parse(response.body)["token"]

      delete "/logout", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Logged out successfully.")
    end

    it "fails to logout without token" do
      delete "/logout"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
