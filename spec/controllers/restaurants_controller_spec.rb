require "rails_helper"

describe RestaurantsController do
  let(:user) { create :user }
  let(:restaurant) { create :restaurant }

  before do
    sign_in_as(user)
    restaurant
  end

  describe "GET /index" do
    it "returns http response :ok" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
      expect(assigns(:restaurants)).to be_present
    end
  end

  describe "GET /new" do
    it "returns http response :ok" do
      get :new

      expect(response).to have_http_status(:ok)
      expect(assigns(:restaurant)).to be_a_new(Restaurant)
    end
  end

  describe "POST /create" do
    context "success" do
      it "add one restaurant and redirect to index page" do
        expect do
          post :create, restaurant: attributes_for(:restaurant)
        end.to change(Restaurant, :count).by(1)

        expect(response).to redirect_to(restaurants_path)
      end
    end

    context "failure" do
      it "doesn't add one restaurant and re-render new page" do
        expect do
          post :create, restaurant: attributes_for(:restaurant).except(:name)
        end.to change(Restaurant, :count).by(0)

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET /show" do
    it "returns http response :ok" do
      get :show, id: restaurant.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
      expect(assigns(:restaurant)).to eq(restaurant)
    end
  end

  describe "GET /edit" do
    it "returns http response :ok" do
      get :edit, id: restaurant.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(assigns(:restaurant)).to eq(restaurant)
    end
  end

  describe "PATCH /update" do
    context "success" do
      let(:restaurant_params) do
        {
          name: "abc",
          address: "address",
          area: "area",
          average_cost: "50",
          people_count: "2",
          known_for_list: "western, pasta"
        }
      end

      it "edit restaurant and redirect to index page" do
        patch :update, id: restaurant.id, restaurant: restaurant_params

        expect(response).to redirect_to(restaurants_path)
        expect(restaurant.reload.name).to eq("abc")
        expect(restaurant.reload.address).to eq("address")
        expect(restaurant.reload.area).to eq("area")
        expect(restaurant.reload.average_cost).to eq(50.0)
        expect(restaurant.reload.people_count).to eq(2)
        expect(restaurant.reload.known_for_list).to include("western")
        expect(restaurant.reload.known_for_list).to include("pasta")
      end
    end

    context "failure" do
      it "doesn't update restaurant and re-render new page" do
        patch :update, id: restaurant.id, restaurant: { name: nil }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /destroy" do
    context "success" do
      it "delete restaurant and redirect to index page" do
        expect {
          delete :destroy, id: restaurant.id
        }.to change(Restaurant, :count).by(-1)

        expect(response).to redirect_to(restaurants_path)
      end
    end

    context "failure" do
      it "doesn't update restaurant and re-render new page" do
        allow(Restaurant).to receive(:find) { restaurant }
        allow(restaurant).to receive(:destroy) { false }

        expect {
          delete :destroy, id: restaurant.id
        }.to change(Restaurant, :count).by(0)

        expect(response).to redirect_to(restaurants_path)
      end
    end
  end
end
