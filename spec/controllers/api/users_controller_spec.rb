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
end
