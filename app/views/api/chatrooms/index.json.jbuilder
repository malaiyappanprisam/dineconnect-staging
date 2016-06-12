json.invites @invites, partial: "api/invites/invite", as: :invite
json.users @users, partial: "api/users/user", as: :user
json.restaurants @restaurants, partial: "api/restaurants/restaurant", as: :restaurant
