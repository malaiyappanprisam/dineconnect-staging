json.id restaurant.id
json.name restaurant.name.to_s
json.address restaurant.address.to_s
json.area restaurant.area.to_s
json.average_cost restaurant.average_cost.to_f
json.people_count restaurant.people_count.to_s
json.known_for restaurant.known_for_list.to_a
json.food_types restaurant.food_types.pluck(:name)
json.facilities restaurant.facilities.pluck(:name)
json.location restaurant.location.to_s
json.cover_url restaurant.cover_id ? attachment_url(restaurant, :cover, :fill, 360, 360, format: "png") : "http://lorempixel.com/360/360/food/#{(restaurant.id > 9 ? 1 + (restaurant.id % 10) : restaurant.id)}/"
json.favorited_users restaurant.find_votes_for.pluck(:voter_id)
json.is_favorited !!(@current_user.try(:voted_for?, restaurant))
json.open_schedules restaurant.open_schedules do |open_schedule|
  json.day open_schedule.day
  json.hour_open open_schedule.hour_open
  json.hour_close open_schedule.hour_close
  json.time_open open_schedule.time_open.try(:strftime, "%H:%M")
  json.time_close open_schedule.time_close.try(:strftime, "%H:%M")
end
