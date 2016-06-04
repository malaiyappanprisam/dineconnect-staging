require "rails_helper"

describe WelcomeController do
  describe "GET /index" do
    it "returns http response :ok" do
      create_list :user, 2

      get :index

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to be_present
    end
  end
end
