json.id restaurant.id
json.name restaurant.name.to_s
json.address restaurant.address.to_s
json.cover_url "http://lorempixel.com/360/360/food/#{restaurant.id}/"
json.favorited_users @users.map(&:id).sample(6)
