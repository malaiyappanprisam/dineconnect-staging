require "rails_helper"

describe Api::InvitesController do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }
  let(:another_user) { create :user }
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
    @request.headers["X-API-Token"] = user_token.token
    @request.headers["X-API-Device"] = user_token.device_id
  end

  describe "POST /create.json" do
    context "success" do
      it "returns ok and create invite" do
        expect do
          post :create, format: :json, invite: { invitee_id: another_user.id }
        end.to change(Invite, :count).by(1)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["channel_group"]).to eq user.reload.channel_group
      end
    end

    context "failure" do
      it "returns unprocessable_entity" do
        create :invite, user: user, invitee: another_user
        expect do
          post :create, format: :json, invite: { invitee_id: another_user.id }
        end.to change(Invite, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
