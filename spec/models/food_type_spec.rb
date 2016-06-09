require 'rails_helper'

describe FoodType do
  it { should have_and_belong_to_many(:restaurants) }
  it { should validate_presence_of(:name) }
end
