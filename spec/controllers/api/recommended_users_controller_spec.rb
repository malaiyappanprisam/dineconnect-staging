require "rails_helper"

describe Api::RecommendedUsersController do
  let!(:users) { create_list :user, 2 }
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
  end

  describe "GET /index.json" do
    it "return list of recommended users" do
      get :index, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to be_present
    end
  end
end
