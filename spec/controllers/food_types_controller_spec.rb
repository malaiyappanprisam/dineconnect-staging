require "rails_helper"

describe FoodTypesController do
  let(:user) { create :user, role: :admin }
  let(:food_type) { create :food_type }

  before do
    sign_in_as(user)
    food_type
  end

  describe "GET /index" do
    it "returns http response :ok" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
      expect(assigns(:food_types)).to be_present
    end
  end

  describe "GET /new" do
    it "returns http response :ok" do
      get :new

      expect(response).to have_http_status(:ok)
      expect(assigns(:food_type)).to be_a_new(FoodType)
    end
  end

  describe "POST /create" do
    context "success" do
      it "add one food_type and redirect to index page" do
        expect do
          post :create, food_type: attributes_for(:food_type)
        end.to change(FoodType, :count).by(1)

        expect(response).to redirect_to(food_types_path)
      end
    end

    context "failure" do
      it "doesn't add one food_type and re-render new page" do
        expect do
          post :create, food_type: { name: nil }
        end.to change(FoodType, :count).by(0)

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET /show" do
    it "returns http response :ok" do
      get :show, id: food_type.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
      expect(assigns(:food_type)).to eq(food_type)
    end
  end

  describe "GET /edit" do
    it "returns http response :ok" do
      get :edit, id: food_type.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(assigns(:food_type)).to eq(food_type)
    end
  end

  describe "PATCH /update" do
    context "success" do
      let(:food_type_params) do
        {
          name: "abc",
        }
      end

      it "edit food_type and redirect to index page" do
        patch :update, id: food_type.id, food_type: food_type_params

        expect(response).to redirect_to(food_types_path)
        expect(food_type.reload.name).to eq("abc")
      end
    end

    context "failure" do
      it "doesn't update food_type and re-render new page" do
        patch :update, id: food_type.id, food_type: { name: nil }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /destroy" do
    context "success" do
      it "delete food_type and redirect to index page" do
        expect {
          delete :destroy, id: food_type.id
        }.to change(FoodType, :count).by(-1)

        expect(response).to redirect_to(food_types_path)
      end
    end

    context "failure" do
      it "doesn't update food_type and re-render new page" do
        allow(FoodType).to receive(:find) { food_type }
        allow(food_type).to receive(:destroy) { false }

        expect {
          delete :destroy, id: food_type.id
        }.to change(FoodType, :count).by(0)

        expect(response).to redirect_to(food_types_path)
      end
    end
  end
end
