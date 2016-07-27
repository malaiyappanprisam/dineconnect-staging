require "rails_helper"

describe RestaurantsController do
  let(:user) { create :user, role: :admin }
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

    it "returns search results" do
      burger_restaurant = create :restaurant, name: "Burger King"
      get :index, search: { name: "burger" }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
      expect(assigns(:restaurants)).to be_present
      expect(assigns(:restaurants)).to include burger_restaurant
      expect(assigns(:restaurants)).not_to include restaurant
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

        expect(response).to redirect_to(restaurant_path(Restaurant.last))
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
    let(:food_type) { create :food_type, name: "western" }
    let(:facility) { create :facility, name: "wifi" }
    let(:area) { create :area, name: "Orchard Rd." }
    context "success" do
      let(:restaurant_params) do
        {
          name: "abc",
          address: "address",
          description: "description",
          phone_number: "+6285694858677",
          area_id: area.id,
          average_cost: "50",
          people_count: "2",
          price: "10_20",
          known_for_list: "burger, pasta",
          food_type_ids: [food_type.id],
          facility_ids: [facility.id],
          location: "-6.214432, 106.813197",
          open_schedules_attributes: [
            { day: "sunday", time_open: "9:30", time_close: "23:30" }
          ]
        }
      end

      it "edit restaurant and redirect to index page" do
        patch :update, id: restaurant.id, restaurant: restaurant_params

        expect(response).to redirect_to(restaurant_path(restaurant.id))
        expect(restaurant.reload.name).to eq("abc")
        expect(restaurant.reload.address).to eq("address")
        expect(restaurant.reload.description).to eq("description")
        expect(restaurant.reload.phone_number).to eq("+6285694858677")
        expect(restaurant.reload.area.name).to eq("Orchard Rd.")
        expect(restaurant.reload.average_cost).to eq(50.0)
        expect(restaurant.reload.people_count).to eq(2)
        expect(restaurant.reload.price).to eq("10_20")
        expect(restaurant.reload.known_for_list).to include("burger")
        expect(restaurant.reload.known_for_list).to include("pasta")
        expect(restaurant.reload.food_types.map(&:name)).to include("western")
        expect(restaurant.reload.facilities.map(&:name)).to include("wifi")
        expect(restaurant.reload.location).to eq("-6.214432, 106.813197")
        expect(restaurant.reload.open_schedules.first).to have_attributes(
          day: "sunday", time_open: Tod::TimeOfDay.parse("09:30"),
          time_close: Tod::TimeOfDay.parse("23:30")
        )
      end
    end

    context "failure" do
      it "doesn't update restaurant and re-render new page" do
        patch :update, id: restaurant.id, restaurant: { name: nil }

        expect(response).to render_template(:edit)
      end
    end
  end


  describe "PATCH /activate" do
    context "success" do
      it "update user to active" do
        restaurant.update(active: false)
        patch :activate, id: restaurant.id

        expect(response).to redirect_to(restaurants_path)
        expect(restaurant.reload.active).to be_truthy
      end
    end
  end

  describe "PATCH /deactivate" do
    context "success" do
      it "update user to inactive" do
        patch :deactivate, id: restaurant.id

        expect(response).to redirect_to(restaurants_path)
        expect(restaurant.reload.active).to be_falsey
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
