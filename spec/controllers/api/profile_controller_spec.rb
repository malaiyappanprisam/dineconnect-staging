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
    let(:user_params) do
      {
        first_name: "Test",
        last_name: "User",
        interested_in_list: "burger, pizza"
      }
    end

    let(:reloaded_user) { user.reload }

    context "valid params" do
      it "returns ok and update user" do
        patch :detail, format: :json, user: user_params

        expect(response).to have_http_status(:ok)
        expect(reloaded_user.first_name).to eq("Test")
        expect(reloaded_user.last_name).to eq("User")
        expect(reloaded_user.interested_in_list).to include("pizza")
        expect(reloaded_user.interested_in_list).to include("burger")
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

  describe "PATCH /profile/avatar.json" do
    let(:file) { Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png") }
    let(:user_params) { { avatar: file } }

    context "success" do
      it "returns ok and update user" do
        patch :avatar, format: :json, user: user_params

        expect(response).to have_http_status(:ok)
      end
    end

    context "failure" do
      let(:stubbed_user) { build_stubbed :user }
      it "returns unprocessable_entity and not update user" do
        allow(controller).to receive(:current_user) { stubbed_user }
        allow(stubbed_user).to receive(:update) { false }

        patch :avatar, format: :json, user: user_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(user.reload.avatar).to be_blank
      end

    end
  end
end
