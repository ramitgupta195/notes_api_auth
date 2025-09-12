require "rails_helper"

RSpec.describe "User Profile", type: :request do
  let(:user) { create(:user, email: "user@example.com", password: "password123", role: :user) }

  def login_and_get_token(account)
    post "/login", params: { user: { email: account.email, password: "password123" } }
    JSON.parse(response.body)["token"]
  end

  describe "GET /users/profile" do
    it "returns the current user's profile with valid JWT" do
      token = login_and_get_token(user)

      get "/users/profile", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["email"]).to eq(user.email)
      expect(json["role"]).to eq("user")
    end

    it "denies access without a token" do
      get "/users/profile"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PATCH /users/profile" do
    it "updates the current user's profile" do
      token = login_and_get_token(user)

      patch "/users/profile",
        params: { user: { email: "updated@example.com" } },
        headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["email"]).to eq("updated@example.com")
    end

    it "fails without a token" do
      patch "/users/profile", params: { user: { email: "updated@example.com" } }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
