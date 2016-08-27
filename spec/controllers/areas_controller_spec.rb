require "rails_helper"

describe AreasController do
  let(:user) { create :user, role: :admin }
  let(:area) { create :area }

  before do
    sign_in_as(user)
    area
  end

  describe "GET /index" do
    it "returns http response :ok" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
      expect(assigns(:areas)).to be_present
    end
  end

  describe "GET /new" do
    it "returns http response :ok" do
      get :new

      expect(response).to have_http_status(:ok)
      expect(assigns(:area)).to be_a_new(Area)
    end
  end

  describe "POST /create" do
    context "success" do
      it "add one area and redirect to index page" do
        expect do
          post :create, area: attributes_for(:area)
        end.to change(Area, :count).by(1)

        expect(response).to redirect_to(areas_path)
      end
    end

    context "failure" do
      it "doesn't add one area and re-render new page" do
        expect do
          post :create, area: { name: nil }
        end.to change(Area, :count).by(0)

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET /show" do
    it "returns http response :ok" do
      get :show, id: area.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
      expect(assigns(:area)).to eq(area)
    end
  end

  describe "GET /edit" do
    it "returns http response :ok" do
      get :edit, id: area.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(assigns(:area)).to eq(area)
    end
  end

  describe "PATCH /update" do
    context "success" do
      let(:area_params) do
        {
          name: "abc",
          digit_of_postal_code: "01"
        }
      end

      it "edit area and redirect to index page" do
        patch :update, id: area.id, area: area_params

        expect(response).to redirect_to(areas_path)
        expect(area.reload.name).to eq("abc")
        expect(area.reload.digit_of_postal_code).to eq("01")
      end
    end

    context "failure" do
      it "doesn't update area and re-render new page" do
        patch :update, id: area.id, area: { name: nil }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /destroy" do
    context "success" do
      it "delete area and redirect to index page" do
        expect {
          delete :destroy, id: area.id
        }.to change(Area, :count).by(-1)

        expect(response).to redirect_to(areas_path)
      end
    end

    context "failure" do
      it "doesn't update area and re-render new page" do
        allow(Area).to receive(:find) { area }
        allow(area).to receive(:destroy) { false }

        expect {
          delete :destroy, id: area.id
        }.to change(Area, :count).by(0)

        expect(response).to redirect_to(areas_path)
      end
    end
  end
end
