require "rails_helper"

describe Api::NationalitiesController do
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
  end

  describe "GET /index.json" do
    it "returns ok and nationalities" do
      get :index, format: :json

      expect(response).to have_http_status(:ok)
      expect(assigns(:nationalities)).to be_present
    end
  end
end
