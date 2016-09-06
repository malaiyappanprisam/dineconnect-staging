require "rails_helper"

describe Api::InvitesController do
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
    it "returns list of people that invite me" do
      create :invite, user: another_user, invitee: user, restaurant: restaurant
      get :index, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:invites)).to be_present
      expect(assigns(:users)).to be_present
      expect(assigns(:restaurants)).to be_present
      expect(assigns(:users)).to include(user)
    end
  end

  describe "POST /create.json" do
    context "success" do
      let(:invite_params) do
        {
          invitee_id: another_user.id,
          restaurant_id: restaurant.id,
          payment_preference: "paying"
        }
      end
      let(:invite) { Invite.last }
      it "returns ok and create invite" do
        expect do
          post :create, format: :json, invite: invite_params
        end.to change(Invite, :count).by(1)

        expect(response).to have_http_status(:ok)
        expect(assigns(:invite)).to be_present
        expect(invite.restaurant).to eq(restaurant)
        expect(invite.payment_preference).to eq("paying")
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
      let(:invite) { create :invite, user: another_user, invitee: user }
      it "returns ok and create invite" do
        post :accept, format: :json, id: invite.id

        expect(response).to have_http_status(:ok)
      end
    end

    context "failure" do
      let(:invite) { create :invite, user: another_user, invitee: user, status: :reject }
      it "returns unprocessable_entity" do
        post :accept, format: :json, id: invite.id

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /reject.json" do
    context "success" do
      let(:invite) { create :invite, user: another_user, invitee: user }
      it "returns ok and create invite" do
        post :reject, format: :json, id: invite.id

        expect(response).to have_http_status(:ok)
      end
    end

    context "failure" do
      let(:invite) { create :invite, user: another_user, invitee: user, status: :accept }
      it "returns unprocessable_entity" do
        post :reject, format: :json, id: invite.id

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /block.json" do
    context "status is accept" do
      let(:invite) { create :invite, user: another_user, invitee: user, status: :accept }
      it "returns ok and change status to block" do
        post :block, format: :json, id: invite.id

        expect(response).to have_http_status(:ok)
        expect(invite.reload.status).to eq("block")
      end
    end

    context "status is block" do
      let(:invite) { create :invite, user: another_user, invitee: user, status: :block }
      it "returns ok and change status to accept" do
        post :block, format: :json, id: invite.id

        expect(response).to have_http_status(:ok)
        expect(invite.reload.status).to eq("accept")
      end
    end
  end

  describe "POST /hide.json" do
    context "showing is true" do
      let(:invite) { create :invite, user: another_user, invitee: user, showing: true }
      it "returns ok and change status to block" do
        post :hide, format: :json, id: invite.id

        expect(response).to have_http_status(:ok)
        expect(invite.reload.showing).to eq(false)
      end
    end

    context "showing is false" do
      let(:invite) { create :invite, user: another_user, invitee: user, showing: false }
      it "returns ok and change status to accept" do
        post :hide, format: :json, id: invite.id

        expect(response).to have_http_status(:ok)
        expect(invite.reload.showing).to eq(true)
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
