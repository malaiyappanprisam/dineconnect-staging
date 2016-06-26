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
end
