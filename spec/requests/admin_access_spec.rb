require "rails_helper"

RSpec.describe "Admin Access", type: :request do
  let(:admin) { create(:user, role: :admin, password: "password123", email: "admin@example.com") }
  let(:user) { create(:user, role: :user, password: "password123", email: "user@example.com") }

  def login_and_get_token(account)
    post "/login", params: { user: { email: account.email, password: "password123" } }
    JSON.parse(response.body)["token"]
  end

  describe "GET /admin/users" do
    it "allows admin to access users list" do
      token = login_and_get_token(admin)

      get "/admin/users", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
    end

    it "denies normal user access" do
      token = login_and_get_token(user)

      get "/admin/users", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:forbidden).or have_http_status(:unauthorized)
    end
  end

  describe "GET /admin/activity_logs" do
    it "allows admin to access activity logs" do
      token = login_and_get_token(admin)

      get "/admin/activity_logs", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
    end

    it "denies normal user access" do
      token = login_and_get_token(user)

      get "/admin/activity_logs", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:forbidden).or have_http_status(:unauthorized)
    end
  end
end
