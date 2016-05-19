require 'rails_helper'

describe Api::UsersController do
  let(:user) { create :user }

  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
  end

  describe "GET /show.json" do
    it "return user detail" do
      get :show, id: user.id, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to be_present
    end
  end

  describe "PATCH /update.json" do
    let(:user_attributes) { { first_name: "first name" } }

    context "success" do
      it "return user detail" do
        patch :update, id: user.id, user: user_attributes, format: :json

        expect(response).to have_http_status(:ok)
        expect(user.reload.first_name).to eq "first name"
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
    end
  end
end