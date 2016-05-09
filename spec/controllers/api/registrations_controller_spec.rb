require 'rails_helper'

describe Api::RegistrationsController do
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
  end

  describe "POST /register" do
    context "success" do
      before do
        json = {
          registration: {
            first_name: "first",
            last_name: "last",
            email: "email@email.com",
            date_of_birth: "1983-01-01",
            gender: 0,
            password: "B"
          }
        }


        post :create, json.to_json, json.merge(format: :json)
      end

      subject { response }

      it "return 200" do
        expect(response).to have_http_status :ok
      end

      it "save user in the database" do
        user = User.last
        expect(user.last_name).to eq "last"
        expect(user.email).to eq "email@email.com"
        expect(user.age).to eq 33
        expect(user.gender).to eq "male"
      end
    end

  end
end
