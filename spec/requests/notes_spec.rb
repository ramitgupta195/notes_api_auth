require "rails_helper"

RSpec.describe "Notes API", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) do
    post "/login", params: { user: { email: user.email, password: "password123" } }
    token = JSON.parse(response.body)["token"]
    { "Authorization" => "Bearer #{token}" }
  end

  describe "GET /notes" do
    before { create_list(:note, 3, user: user) }

    it "returns all notes for the user" do
      get "/notes", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "POST /notes" do
    it "creates a new note" do
      post "/notes", params: { note: { title: "New Note", content: "Note content" } }, headers: auth_headers
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["title"]).to eq("New Note")
    end
  end

  describe "PUT /notes/:id" do
    let(:note) { create(:note, user: user) }

    it "updates a note" do
      put "/notes/#{note.id}", params: { note: { title: "Updated Title" } }, headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["title"]).to eq("Updated Title")
    end
  end

  describe "DELETE /notes/:id" do
    let(:note) { create(:note, user: user) }

    it "deletes a note" do
      delete "/notes/#{note.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Note deleted successfully.")
    end
  end
end
