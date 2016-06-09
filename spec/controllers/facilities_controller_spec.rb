require "rails_helper"

describe FacilitiesController do
  let(:user) { create :user }
  let(:facility) { create :facility }

  before do
    sign_in_as(user)
    facility
  end

  describe "GET /index" do
    it "returns http response :ok" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
      expect(assigns(:facilities)).to be_present
    end
  end

  describe "GET /new" do
    it "returns http response :ok" do
      get :new

      expect(response).to have_http_status(:ok)
      expect(assigns(:facility)).to be_a_new(Facility)
    end
  end

  describe "POST /create" do
    context "success" do
      it "add one facility and redirect to index page" do
        expect do
          post :create, facility: attributes_for(:facility)
        end.to change(Facility, :count).by(1)

        expect(response).to redirect_to(facilities_path)
      end
    end

    context "failure" do
      it "doesn't add one facility and re-render new page" do
        expect do
          post :create, facility: { name: nil }
        end.to change(Facility, :count).by(0)

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET /show" do
    it "returns http response :ok" do
      get :show, id: facility.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
      expect(assigns(:facility)).to eq(facility)
    end
  end

  describe "GET /edit" do
    it "returns http response :ok" do
      get :edit, id: facility.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(assigns(:facility)).to eq(facility)
    end
  end

  describe "PATCH /update" do
    context "success" do
      let(:facility_params) do
        {
          name: "abc",
        }
      end

      it "edit facility and redirect to index page" do
        patch :update, id: facility.id, facility: facility_params

        expect(response).to redirect_to(facilities_path)
        expect(facility.reload.name).to eq("abc")
      end
    end

    context "failure" do
      it "doesn't update facility and re-render new page" do
        patch :update, id: facility.id, facility: { name: nil }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /destroy" do
    context "success" do
      it "delete facility and redirect to index page" do
        expect {
          delete :destroy, id: facility.id
        }.to change(Facility, :count).by(-1)

        expect(response).to redirect_to(facilities_path)
      end
    end

    context "failure" do
      it "doesn't update facility and re-render new page" do
        allow(Facility).to receive(:find) { facility }
        allow(facility).to receive(:destroy) { false }

        expect {
          delete :destroy, id: facility.id
        }.to change(Facility, :count).by(0)

        expect(response).to redirect_to(facilities_path)
      end
    end
  end
end
