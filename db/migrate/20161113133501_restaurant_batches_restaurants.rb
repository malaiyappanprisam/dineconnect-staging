class RestaurantBatchesRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurant_batches_restaurants, id: false do |t|
      t.belongs_to :restaurant_batch, index: true
      t.belongs_to :restaurant, index: true
    end
  end
end
