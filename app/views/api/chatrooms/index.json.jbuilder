json.invites @invites, partial: "api/invites/invite", as: :invite
json.restaurants @restaurants, partial: "api/restaurants/restaurant", as: :restaurant
json.users @users, partial: "api/users/user", as: :user
json.food_types FoodType.all, partial: "api/food_types/food_type", as: :food_type
json.facilities Facility.all, partial: "api/facilities/facility", as: :facility
