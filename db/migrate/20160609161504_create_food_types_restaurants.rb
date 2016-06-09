class CreateFoodTypesRestaurants < ActiveRecord::Migration
  def change
    create_table :food_types_restaurants do |t|
      t.references :food_type, index: true
      t.references :restaurant, index: true
    end
  end
end
