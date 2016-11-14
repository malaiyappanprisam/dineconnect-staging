require 'rails_helper'

describe RestaurantBatch do
  it { should validate_presence_of(:latlong) }
  it { should validate_presence_of(:radius) }
  it { should have_and_belong_to_many(:restaurants) }
end
