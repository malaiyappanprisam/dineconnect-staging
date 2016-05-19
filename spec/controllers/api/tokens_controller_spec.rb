require "rails_helper"

describe Api::TokensController do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }
  let!(:restaurants) { create_list :restaurant, 2 }

  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
  end

  describe "POST /check.json" do
    context "success" do
      it "returns ok" do
        @request.headers["X-API-Token"] = user_token.token
        @request.headers["X-API-Device"] = user_token.device_id

        post :check, format: :json

        expect(response).to have_http_status :ok
      end
    end

    context "failure" do
      it "returns unauthorized" do
        @request.headers["X-API-Token"] = "some_random_token"
        @request.headers["X-API-Device"] = user_token.device_id

        post :check, format: :json

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
