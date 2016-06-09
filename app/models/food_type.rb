class FoodType < ActiveRecord::Base
  validates :name, presence: true
end
