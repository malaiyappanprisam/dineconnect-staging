require 'rails_helper'

describe Api::UsersController do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }

  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
    @request.headers["X-API-Token"] = user_token.token
    @request.headers["X-API-Device"] = user_token.device_id
  end

  describe "GET /show.json" do
    it "return user detail" do
      get :show, id: user.id, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to be_present
    end
  end

  describe "PATCH /update.json" do
    let(:user_attributes) { { first_name: "first name", about_me: "about me" } }

    context "success" do
      it "return user detail" do
        patch :update, id: user.id, user: user_attributes, format: :json

        expect(response).to have_http_status(:ok)
        expect(user.reload.first_name).to eq "first name"
        expect(user.reload.about_me).to eq "about me"
      end
    end

    context "failure" do
      let(:stubbed_user) { build_stubbed :user }

      it "return user detail" do
        allow(User).to receive(:find) { stubbed_user }
        allow(stubbed_user).to receive(:update) { false }

        patch :update, id: user.id, user: user_attributes, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /recommended_restaurants.json" do
    let!(:restaurants) { create_list :restaurant, 2 }

    it "returns list of recommended restaurants" do
      get :recommended_restaurants, id: user.id, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:restaurants)).to be_present
      expect(assigns(:users)).to be_present
    end
  end

  describe "GET /favorited_restaurants.json" do
    let!(:restaurant) { create :restaurant }

    it "returns list of recommended restaurants" do
      restaurant.liked_by user
      get :favorited_restaurants, id: user.id, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:restaurants)).to be_present
      expect(assigns(:user)).to eq(user)
      expect(assigns(:users)).to include(user)
    end
  end
end
