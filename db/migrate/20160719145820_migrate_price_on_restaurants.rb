class MigratePriceOnRestaurants < ActiveRecord::Migration
  def up
    Restaurant.all.each do |restaurant|
      if restaurant.average_cost.to_i <= 10
        restaurant.price = :"0_10"
      elsif restaurant.average_cost.to_i > 10 && restaurant.average_cost.to_i <= 20
        restaurant.price = :"10_20"
      elsif restaurant.average_cost.to_i > 20 && restaurant.average_cost.to_i <= 30
        restaurant.price = :"20_30"
      elsif restaurant.average_cost.to_i > 30 && restaurant.average_cost.to_i <= 40
        restaurant.price = :"30_40"
      elsif restaurant.average_cost.to_i > 40 && restaurant.average_cost.to_i <= 50
        restaurant.price = :"40_50"
      elsif restaurant.average_cost.to_i > 50 && restaurant.average_cost.to_i <= 75
        restaurant.price = :"50_75"
      elsif restaurant.average_cost.to_i > 75 && restaurant.average_cost.to_i <= 100
        restaurant.price = :"75_100"
      elsif restaurant.average_cost.to_i > 100 && restaurant.average_cost.to_i <= 150
        restaurant.price = :"100_150"
      elsif restaurant.average_cost.to_i > 150 && restaurant.average_cost.to_i <= 200
        restaurant.price = :"150_200"
      elsif restaurant.average_cost.to_i > 200
        restaurant.price = :"200_above"
      end

      restaurant.save
    end
  end

  def down

  end
end
