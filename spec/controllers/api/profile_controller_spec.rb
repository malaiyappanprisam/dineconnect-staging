require "rails_helper"
require "refile/file_double"

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

  describe "GET /profile/me.json" do
    it "returns ok" do
      get :me, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to be_present
      expect(assigns(:users)).to include(user)
    end
  end

  describe "PATCH /profile/detail.json" do
    let(:user_params) do
      {
        first_name: "Test",
        last_name: "User",
        interested_in_list: "burger, pizza",
        favorite_food_list: "tempe, tahu",
        onboard: true
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
        expect(reloaded_user.favorite_food_list).to include("tempe")
        expect(reloaded_user.favorite_food_list).to include("tahu")
        expect(reloaded_user.onboard).to eq(true)
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

  describe "POST /profile/forgot_password.json" do
    let!(:user) { create :user, email: "email@example.org" }

    it "returns ok and send email" do
      sign_out
      expect_any_instance_of(Api::ProfileController).to receive(:deliver_email)
      post :forgot_password, format: :json, password: { email: "email@example.org" }

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /profile/password.json" do
    let(:user) { create :user, password: "somepassword" }

    context "success" do
      let(:user_params) do
        {
          current_password: "somepassword",
          password: "somenewpassword",
          password_confirmation: "somenewpassword",
        }
      end

      it "returns ok and update the password" do
        patch :password, format: :json, user: user_params

        expect(response).to have_http_status(:ok)
      end
    end

    context "failure" do
      let(:user_params) do
        {
          current_password: "notsamepassword",
          password: "somenewpassword",
          password_confirmation: "abcsomenewpassword",
        }
      end

      it "returns unprocessable_entity" do
        patch :password, format: :json, user: user_params

        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "PATCH /profile/location.json" do
    let!(:user) { create :user, email: "email@example.org" }
    let(:location_params) { { latitude: "-6.214432", longitude: "106.813197",
                              district: "orchard rd" } }

    it "returns ok and change the user location" do
      patch :location, format: :json, user: location_params

      expect(response).to have_http_status(:ok)
      expect(user.reload.location).to eq "-6.214432, 106.813197"
      expect(user.reload.district).to eq "orchard rd"
    end
  end

  describe "PATCH /deactivate" do
    context "success" do
      it "update user to inactive" do
        patch :deactivate, format: :json

        expect(response).to have_http_status(:ok)
        expect(user.reload.active).to be_falsey
      end
    end
  end

end
