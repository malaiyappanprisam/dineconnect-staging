class FoodType < ActiveRecord::Base
  has_and_belongs_to_many :restaurants
  validates :name, presence: true
end
