require "rails_helper"

describe Api::RecommendedRestaurantsController do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }
  let!(:restaurants) { create_list :restaurant, 2 }
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
    @request.headers["X-API-Token"] = user_token.token
    @request.headers["X-API-Device"] = user_token.device_id
  end

  describe "GET /index.json" do
    it "returns list of recommended restaurants" do
      get :index, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:restaurants)).to be_present
      expect(assigns(:users)).to be_present
    end
  end
end
