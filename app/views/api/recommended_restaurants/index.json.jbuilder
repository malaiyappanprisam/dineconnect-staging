json.restaurants @restaurants do |restaurant|
  json.id restaurant.id
  json.name restaurant.name
  json.address restaurant.address
  json.cover_url Faker::Placeholdit.image("300x300", 'jpg', 'ffffff', '000', restaurant.name.gsub(/\s+/, ""))
end
