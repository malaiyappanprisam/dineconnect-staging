require "rails_helper"

describe Api::RecommendedRestaurantsController do
  let!(:restaurants) { create_list :restaurant, 2 }
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
  end

  describe "GET /index.json" do
    it "returns list of recommended restaurants" do
      get :index, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:restaurants)).to be_present
    end
  end
end
