json.id user.id
if @token.present?
  json.token @token.token
end
json.email user.email.to_s
json.username user.username.to_s
json.first_name user.first_name.to_s
json.last_name user.last_name.to_s
json.about_me user.about_me.to_s
json.gender user.gender.to_s
json.date_of_birth user.date_of_birth.to_s
json.age user.age.to_s
json.profession user.profession.to_s
json.nationality user.humanize_nationality.to_s
json.residence_status user.residence_status.to_s
json.interested_to_meet user.interested_to_meet.to_s
json.payment_preference user.payment_preference.to_s
json.avatar_url user.avatar_id ? attachment_url(user, :avatar, :fill, 300, 300, format: "jpg") : "https://api.adorable.io/avatars/300/#{user.id}.png"
json.interested_in_list user.interested_in_list.to_a
json.favorite_food_list user.favorite_food_list.to_a
json.location user.location.to_s
json.longitude user.long.to_f
json.latitude user.lat.to_f
json.district user.district
json.channel_group user.channel_group.to_s
json.photos user.photos, partial: "api/photos/photo", as: :photo
json.validated_with_facebook user.validated_with_facebook
json.onboard user.onboard
