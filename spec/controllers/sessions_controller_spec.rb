require "rails_helper"

describe SessionsController do

  describe "POST /create" do
    let(:parameters) do
      { email: "user@dineconnectapp.com", password: "testuser" }
    end

    context "admin user" do
      let!(:user) { create :user, email: "user@dineconnectapp.com", password: "testuser", role: :admin }
      it "allowed to login" do
        post :create, session: parameters

        expect(response).to redirect_to(root_path)
      end
    end

    context "normal user" do
      let!(:user) { create :user, email: "user@dineconnectapp.com", password: "testuser" }
      it "not allowed to login" do
        post :create, session: parameters

        expect(response).to render_template("new")
      end
    end
  end
end
