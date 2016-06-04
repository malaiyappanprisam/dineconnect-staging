json.invites @invites do |invite|
  json.id invite.id
  json.user_id invite.user_id
  json.invitee_id invite.invitee_id
  json.restaurant_id invite.restaurant_id
  json.status invite.status
end

json.users @users, partial: "api/users/user", as: :user
json.restaurants @restaurants, partial: "api/restaurants/restaurant", as: :restaurant
