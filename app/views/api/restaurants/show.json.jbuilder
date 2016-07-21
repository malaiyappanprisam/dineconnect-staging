json.restaurants @restaurants, partial: 'api/restaurants/restaurant', as: :restaurant
json.users @users, partial: "api/users/user", as: :user
json.food_types @food_types, partial: "api/food_types/food_type", as: :food_type
json.facilities @facilities, partial: "api/facilities/facility", as: :facility
