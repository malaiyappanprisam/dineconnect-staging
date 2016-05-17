require 'rails_helper'

describe Api::RestaurantsController do
  let(:restaurant) { create :restaurant }

  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
  end

  describe "GET /recommended_users.json" do
    let!(:users) { create_list :user, 2 }

    it "returns list of recommended restaurants" do
      get :recommended_users, id: restaurant.id, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to be_present
    end
  end
end
