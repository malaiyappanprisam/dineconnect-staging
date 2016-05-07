require "rails_helper"

describe ApiController do
  controller do
    def index
      head 200
    end
  end

  describe "GET /any_method" do
    it "render error unauthorized" do
      stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "gfedcba"))

      @request.headers["X-API-AUTH"] = "abcdefg"
      get :index

      expect(response).to have_http_status(:unauthorized)
    end

    it "render 200" do
      stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))

      @request.headers["X-API-AUTH"] = "abcdefg"
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
