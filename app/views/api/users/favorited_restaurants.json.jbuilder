json.restaurants @restaurants, partial: "api/restaurants/restaurant", as: :restaurant
json.food_types FoodType.all, partial: "api/food_types/food_type", as: :food_type
json.facilities Facility.all, partial: "api/facilities/facility", as: :facility
