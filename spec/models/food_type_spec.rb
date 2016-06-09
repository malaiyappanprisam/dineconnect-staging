require 'rails_helper'

describe FoodType do
  it { should validate_presence_of(:name) }
end
