class RestaurantBatch < ActiveRecord::Base
  validates :latlong, presence: true
  validates :radius, presence: true

  has_and_belongs_to_many :restaurants
end
