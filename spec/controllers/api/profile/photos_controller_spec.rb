require "rails_helper"

describe Api::Profile::PhotosController do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: user }
  before do
    stub_const("ENV", ENV.to_hash.merge("API_AUTH_KEY" => "abcdefg"))
    @request.headers["X-API-AUTH"] = "abcdefg"
    @request.headers["X-API-Token"] = user_token.token
    @request.headers["X-API-Device"] = user_token.device_id
  end

  describe "POST /create.json" do
    let(:file) { Refile::FileDouble.new("dummy", "logo.jpg", content_type: "image/jpg") }
    let(:user_params) { { photos_files: [ file ] } }

    context "success" do
      it "returns ok and update user" do
        post :create, format: :json, user: user_params

        expect(response).to have_http_status(:ok)
      end
    end

    context "failure" do
      let(:stubbed_user) { build_stubbed :user }

      it "returns unprocessable_entity and not update user" do
        allow(controller).to receive(:current_user) { stubbed_user }
        allow(stubbed_user).to receive(:update) { false }

        post :create, format: :json, user: user_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy.json" do
    let(:file) { Refile::FileDouble.new("dummy", "logo.jpg", content_type: "image/jpg") }
    let(:user) { create :user, photos_files: [ file ] }
    let(:photo_id) { user.photos.first.id }

    context "success" do
      it "returns 200 and delete the file" do
        expect {
          delete :destroy, format: :json, id: photo_id
        }.to change(user.photos, :count).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end

    context "failure" do
      it "returns 422" do
        allow_any_instance_of(Photo).to receive(:destroy).and_return(false)
        expect {
          delete :destroy, format: :json, id: photo_id
        }.to change(user.photos, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
