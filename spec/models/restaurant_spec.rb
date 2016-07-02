require 'rails_helper'

describe Restaurant do
  it { should have_many(:open_schedules) }
  it { should have_and_belong_to_many(:food_types) }
  it { should have_and_belong_to_many(:facilities) }
  it { should have_many(:photos) }

  it { should accept_nested_attributes_for(:open_schedules) }

  it { should validate_presence_of(:name) }

  it "accepts known_for_list" do
    restaurant = Restaurant.new(known_for_list: "western, pasta")
    expect(restaurant.known_for_list).to include("western")
    expect(restaurant.known_for_list).to include("pasta")
  end

  it "accepts location" do
    restaurant = Restaurant.new(location: "-6.214432, 106.813197")
    expect(restaurant.location_original).to eq("POINT (106.813197 -6.214432)")
    expect(restaurant.location).to eq("-6.214432, 106.813197")
    expect(restaurant.lat).to eq("-6.214432")
    expect(restaurant.long).to eq("106.813197")
  end

  describe "scope" do
    describe "#nearby" do
      let!(:restaurant) { create :restaurant, location: "-6.214432, 106.813197" }
      it "returns nearby restaurant" do
        nearby_restaurant = Restaurant.nearby("-6.214432", "106.813198")

        expect(nearby_restaurant).to include(restaurant)
      end
    end
  end

  describe "#explore_places" do
    context "with filter" do
      let!(:restaurant) { create :restaurant, name: "Burger King" }

      it "returns restaurant that contain that name" do
        expect(Restaurant.explore_places(filter: "burger")).to include(restaurant)
      end
    end

    context "with food_type_ids" do
      let!(:food_types) { create_list :food_type, 2 }
      let!(:restaurant_1) { create :restaurant, food_types: [food_types.first] }
      let!(:restaurant_2) { create :restaurant, food_types: [food_types.second] }
      let!(:restaurant_3) { create :restaurant }
      let(:food_type_ids) { food_types.map(&:id).join(", ") }

      it "returns restaurant that have that food type" do
        expect(Restaurant.explore_places(food_type_ids: food_type_ids)).to include(restaurant_1)
        expect(Restaurant.explore_places(food_type_ids: food_type_ids)).to include(restaurant_2)
        expect(Restaurant.explore_places(food_type_ids: food_type_ids)).not_to include(restaurant_3)
      end
    end

    context "with facility_ids" do
      let!(:facilities) { create_list :facility, 2 }
      let!(:restaurant_1) { create :restaurant, facilities: [facilities.first] }
      let!(:restaurant_2) { create :restaurant, facilities: [facilities.second] }
      let!(:restaurant_3) { create :restaurant }
      let(:facility_ids) { facilities.map(&:id).join(", ") }

      it "returns restaurant that have that facility" do
        expect(Restaurant.explore_places(facility_ids: facility_ids)).to include(restaurant_1)
        expect(Restaurant.explore_places(facility_ids: facility_ids)).to include(restaurant_2)
        expect(Restaurant.explore_places(facility_ids: facility_ids)).not_to include(restaurant_3)
      end
    end
  end
end
