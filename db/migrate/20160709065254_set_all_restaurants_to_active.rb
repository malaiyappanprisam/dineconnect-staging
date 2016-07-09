class SetAllRestaurantsToActive < ActiveRecord::Migration
  def change
    Restaurant.all.each do |restaurant|
      restaurant.update(active: true)
    end
  end
end
