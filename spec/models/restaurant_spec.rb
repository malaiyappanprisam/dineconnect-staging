require 'rails_helper'

describe Restaurant do
  it { should have_many(:open_schedules) }

  it { should accept_nested_attributes_for(:open_schedules) }

  it { should validate_presence_of(:name) }

  it "accepts known_for_list" do
    restaurant = Restaurant.new(known_for_list: "western, pasta")
    expect(restaurant.known_for_list).to include("western")
    expect(restaurant.known_for_list).to include("pasta")
  end
end
