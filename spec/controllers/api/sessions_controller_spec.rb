require 'rails_helper'
require 'json'

describe Api::SessionsController do
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"

  end

  describe "POST /login" do
    context "Success" do
      let!(:user) { create :user, password: "12345", email: "example@example.com" }
      before do 
        json = {
          session: {
            email: "example@example.com",
            password: "12345"
          }
        }
        post :create, json.to_json, json.merge(format: :json)
      end

      subject { response }

      it "return 200" do
        expect(response).to have_http_status :ok
      end

      it "return user object" do
        expect(assigns(:user)).to be_present
        expect(assigns(:token)).to be_present
      end

      it "render template" do
        expect(response).to render_template('api/sessions/user')
      end
    end

    context "Failed" do
      let!(:user) { create :user, password: "12345", email: "example@example.com" }
      before do
        json = {
          session: {
            email: "example@example.com",
            password: "1"
          }
        }

        post :create, json.to_json, json.merge(format: :json)
      end

      it "return 400" do
        expect(response).to have_http_status :unauthorized
      end
    end

    context "user inactive" do
      let!(:user) { create :user, active: false, password: "12345", email: "example@example.com" }
      before do
        json = {
          session: {
            email: "example@example.com",
            password: "12345"
          }
        }
        post :create, json.to_json, json.merge(format: :json)
      end

      subject { response }

      it "return 400" do
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
