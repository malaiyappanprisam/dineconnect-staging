require "rails_helper"

describe Api::ProfileController do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }
  let!(:restaurants) { create_list :restaurant, 2 }
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
    @request.headers["X-API-Token"] = user_token.token
    @request.headers["X-API-Device"] = user_token.device_id
  end

  describe "PATCH /profile/detail.json" do
    let(:user_params) { { first_name: "Test", last_name: "User" } }

    context "valid params" do
      it "returns ok and update user" do
        patch :detail, format: :json, user: user_params

        expect(response).to have_http_status(:ok)
        expect(user.reload.first_name).to eq("Test")
        expect(user.reload.last_name).to eq("User")
      end
    end

    context "invalid params" do
      let(:user_params) { { email: "" } }
      let(:stubbed_user) { build_stubbed :user }

      it "returns ok" do
        allow(controller).to receive(:current_user) { stubbed_user }
        allow(stubbed_user).to receive(:update) { false }
        patch :detail, format: :json, user: user_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
