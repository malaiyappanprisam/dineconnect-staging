json.id restaurant.id
json.name restaurant.name.to_s
json.address restaurant.address.to_s
json.description restaurant.description.to_s
json.phone_number restaurant.phone_number.to_s
json.area restaurant.area.try(:name).to_s
json.average_cost restaurant.average_cost.to_f
json.people_count restaurant.people_count.to_s
json.price restaurant.price.to_s.split("_").join(" - ")
json.known_for restaurant.known_for_list.to_a
json.food_types restaurant.food_types.pluck(:name)
json.food_types_ids restaurant.food_types.pluck(:id)
json.facilities restaurant.facilities.pluck(:name)
json.facilities_ids restaurant.facilities.pluck(:id)
json.location restaurant.location.to_s
json.long restaurant.long.to_s
json.lat restaurant.lat.to_s
json.longitude restaurant.long.to_f
json.latitude restaurant.lat.to_f
json.cover_url restaurant.cover_id ? attachment_url(restaurant, :cover, :fill, 360, 360, format: "jpg") : "http://lorempixel.com/360/360/food/#{(restaurant.id > 9 ? 1 + (restaurant.id % 10) : restaurant.id)}/"
json.favorited_users restaurant.find_votes_for.pluck(:voter_id)
json.is_favorited !!(@current_user.try(:voted_for?, restaurant))
json.open_schedules restaurant.open_schedules do |open_schedule|
  json.day open_schedule.day
  json.hour_open open_schedule.hour_open
  json.hour_close open_schedule.hour_close
  json.time_open open_schedule.time_open.try(:strftime, "%H:%M")
  json.time_close open_schedule.time_close.try(:strftime, "%H:%M")
end
json.photos restaurant.photos.map { |photo| { id: photo.id, url: attachment_url(photo, :file, :fill, 300, 300, format: "jpg") } }
