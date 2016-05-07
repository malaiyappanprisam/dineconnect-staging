require "rails_helper"

describe WelcomeController do
  describe "GET /index" do
    it "returns http response :ok" do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
