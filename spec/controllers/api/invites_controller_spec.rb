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


  describe "POST /accept.json" do
    context "success" do
      it "returns ok and create invite" do
        create :invite, user: another_user, invitee: user
        post :accept, format: :json, invite: { user_id: another_user.id }

        expect(response).to have_http_status(:ok)
      end
    end

    context "failure" do
      it "returns unprocessable_entity" do
        create :invite, user: another_user, invitee: user, status: :reject
        post :accept, format: :json, invite: { user_id: another_user.id }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /reject.json" do
    context "success" do
      it "returns ok and create invite" do
        create :invite, user: another_user, invitee: user
        post :reject, format: :json, invite: { user_id: another_user.id }

        expect(response).to have_http_status(:ok)
      end
    end

    context "failure" do
      it "returns unprocessable_entity" do
        create :invite, user: another_user, invitee: user, status: :accept
        post :reject, format: :json, invite: { user_id: another_user.id }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy.json" do
    context "success" do
      let(:invite) { create :invite, user: another_user, invitee: user }
      it "returns ok and delete invite" do
        delete :destroy, format: :json, id: invite.id

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
