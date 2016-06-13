require "rails_helper"

describe ApiController do
  describe "GET /any_method" do
    describe "#check_api_auth_key!" do
      controller do
        def index
          head 200
        end
      end

      context "valid" do
        it "render 200" do
          stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))

          @request.headers["X-API-AUTH"] = "abcdefg"
          get :index

          expect(response).to have_http_status(:ok)
        end
      end

      context "invalid" do
        it "render error unauthorized" do
          stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "gfedcba"))

          @request.headers["X-API-AUTH"] = "abcdefg"
          get :index

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe "#authenticate_token!" do
      controller do
        def index
          authenticate_token!
          head 200
        end
      end

      let(:user) { create :user }
      let!(:user_token) { create :user_token, user: user }
      before do
        stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
        @request.headers["X-API-AUTH"] = "abcdefg"
      end

      context "valid" do
        it "render 200" do
          @request.headers["X-API-Token"] = user_token.token
          @request.headers["X-API-Device"] = user_token.device_id

          get :index

          expect(response).to have_http_status(:ok)
        end
      end

      context "invalid" do
        it "render error unauthorized" do
          get :index

          expect(response).to have_http_status(:unauthorized)
        end

        context "user is deleted" do
          it "render error unauthorized" do
            user.destroy

            @request.headers["X-API-Token"] = user_token.token
            @request.headers["X-API-Device"] = user_token.device_id

            get :index

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end
end
