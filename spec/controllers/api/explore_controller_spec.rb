require "rails_helper"

describe Api::ExploreController do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }
  let!(:restaurants) { create_list :restaurant, 2, name: "Burger", location: "-6.214432, 106.813197" }
  let!(:users) { create_list :user, 2 }
  let!(:nearby_user) { create :user, location: "-6.214432, 106.813197" }
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
      expect(assigns(:users)).to be_blank
      expect(assigns(:restaurants)).to be_blank
    end

    context "with lat long" do
      it "returns nearby restaurant and user" do
        get :nearby, format: :json, lat: "-6.214432", long: "106.813198", distance: 10_000

        expect(response).to have_http_status(:ok)
        expect(assigns(:users)).to be_present
        expect(assigns(:users)).to include(nearby_user)
        expect(assigns(:restaurants)).to be_present
        expect(assigns(:restaurants)).to include(restaurants.first)
      end
    end
  end

  describe "GET /places.json" do
    it "returns ok" do
      restaurants.first.liked_by(users.first)

      get :places, format: :json, filter: "burger"

      expect(response).to have_http_status(:ok)
      expect(assigns(:restaurants)).to be_present
      expect(assigns(:users)).to be_present
    end
  end

  describe "GET /places_options.json" do
    it "returns ok" do
      create :food_type
      create :facility

      get :places_options, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:food_types)).to be_empty
      expect(assigns(:facilities)).to be_present
    end
  end
end
