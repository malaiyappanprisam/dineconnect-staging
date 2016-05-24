json.id restaurant.id
json.name restaurant.name.to_s
json.address restaurant.address.to_s
json.cover_url Faker::Placeholdit.image("300x300", 'jpg', 'ffffff', '000', restaurant.name.gsub(/\s+/, ""))
json.favorited_users @users.map(&:id).sample(6)
