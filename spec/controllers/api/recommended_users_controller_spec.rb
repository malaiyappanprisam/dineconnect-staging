require "rails_helper"

describe Api::RecommendedUsersController do
  let!(:users) { create_list :user, 2 }
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
    @request.headers["X-API-Token"] = user_token.token
    @request.headers["X-API-Device"] = user_token.device_id
  end

  describe "GET /index.json" do
    it "return list of recommended users" do
      get :index, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to be_present
    end
  end
end
