require 'rails_helper'
require "refile/file_double"

describe Api::RegistrationsController do
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
  end

  describe "POST /register" do
    context "success" do
      let(:file) { Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png") }
      let(:registration_params) do
        {
          first_name: "first",
          last_name: "last",
          email: "email@email.com",
          date_of_birth: "1983-01-01",
          gender: "male",
          password: "B",
          interested_to_meet: "only_female",
          avatar: file
        }
      end

      before do
        post :create, registration: registration_params, format: :json
      end

      it "return 200" do
        expect(response).to have_http_status :ok
      end

      it "save user in the database" do
        user = User.last
        expect(user.last_name).to eq "last"
        expect(user.email).to eq "email@email.com"
        expect(user.age).to eq 33
        expect(user.gender).to eq "male"
        expect(user.interested_to_meet).to eq("only_female")
      end
    end
  end
end
