require "rails_helper"

describe Api::RestaurantFavoritesController do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }
  let!(:restaurant) { create :restaurant }
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
    @request.headers["X-API-Token"] = user_token.token
    @request.headers["X-API-Device"] = user_token.device_id
  end

  describe "POST /create.json" do
    context "success" do
      context "not favorited yet" do
        it "returns 200" do
          expect {
            post :create, format: :json, restaurant_id: restaurant.id
          }.to change(restaurant.get_likes, :size).by(1)

          expect(response).to have_http_status(:ok)
        end
      end

      context "already favorited" do
        it "returns 200" do
          user.likes restaurant
          expect {
            post :create, format: :json, restaurant_id: restaurant.id
          }.to change(restaurant.get_likes, :size).by(-1)

          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "POST /destroy.json" do
    context "success" do
      it "returns 200" do
        user.likes restaurant
        expect {
          delete :destroy, format: :json, id: restaurant.id
        }.to change(restaurant.get_likes, :size).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
