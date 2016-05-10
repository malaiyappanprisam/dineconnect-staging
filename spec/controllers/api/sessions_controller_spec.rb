require 'rails_helper'

describe Api::SessionsController do

  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
    
    create :user, password: "12345", email: "example@example.com"
  end

  describe "POST /login" do
    context "Success", :focus do
      before do 
        json = {
          session: {
            email: "example@example.com",
            password: "12345"
          }
        }
        post :create, json.to_json, json.merge(format: :json)
      end

      it "return 200" do
        expect(response).to have_http_status :ok
      end
    end

    context "Failed" do
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
  end

end
