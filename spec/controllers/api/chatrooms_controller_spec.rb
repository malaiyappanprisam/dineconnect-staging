require "rails_helper"

describe Api::ChatroomsController do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }
  let(:another_user) { create :user }
  let(:restaurant) { create :restaurant }
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
    @request.headers["X-API-Token"] = user_token.token
    @request.headers["X-API-Device"] = user_token.device_id
  end

  describe "GET /index.json" do
    it "returns 200" do
      create :invite, :accepted, user: another_user, invitee: user, restaurant: restaurant
      get :index, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:invites)).to be_present
      expect(assigns(:users)).to be_present
      expect(assigns(:restaurants)).to be_present
      expect(assigns(:users)).to include(user)
      expect(assigns(:users)).to include(another_user)
    end

    context "empty invites" do
      it "returns 200" do
        create :invite, user: another_user, invitee: user, restaurant: restaurant, status: :accept
        get :index, format: :json

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
