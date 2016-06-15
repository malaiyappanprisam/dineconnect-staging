require 'rails_helper'

describe Api::RestaurantsController do
  let(:restaurant) { create :restaurant }
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }

  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
    @request.headers["X-API-Token"] = user_token.token
    @request.headers["X-API-Device"] = user_token.device_id
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
