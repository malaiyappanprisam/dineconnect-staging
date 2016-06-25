require "rails_helper"

describe Api::ExploreController do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }
  let!(:restaurants) { create_list :restaurant, 2, location: "-6.214432, 106.813197" }
  let!(:users) { create_list :user, 2 }
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
    @request.headers["X-API-Token"] = user_token.token
    @request.headers["X-API-Device"] = user_token.device_id
  end

  describe "GET /people.json" do
    it "returns ok" do
      get :people, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to be_present
    end
  end

  describe "GET /nearby.json" do
    it "returns ok" do
      get :nearby, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to be_present
      expect(assigns(:restaurants)).to be_present
    end

    context "with lat long" do
      it "returns nearby restaurant" do
        get :nearby, format: :json, lat: "-6.214432", long: "106.813198", distance: 10_000

        expect(response).to have_http_status(:ok)
        expect(assigns(:users)).to be_present
        expect(assigns(:restaurants)).to be_present
      end
    end
  end

  describe "GET /places.json" do
    it "returns ok" do
      get :places, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:restaurants)).to be_present
      expect(assigns(:users)).to be_present
    end
  end
end
