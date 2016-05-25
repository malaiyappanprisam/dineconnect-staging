json.id restaurant.id
json.name restaurant.name.to_s
json.address restaurant.address.to_s
json.area restaurant.area.to_s
json.average_cost restaurant.average_cost.to_f
json.people_count restaurant.people_count.to_s
json.known_for restaurant.known_for_list
json.cover_url "http://lorempixel.com/360/360/food/#{(restaurant.id > 9 ? 1 + (restaurant.id % 10) : restaurant.id)}/"
json.favorited_users @users.map(&:id).sample(6)
