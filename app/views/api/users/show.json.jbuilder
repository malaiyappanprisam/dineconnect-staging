json.users @users do |user|
  json.id user.id
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
  json.avatar_url Faker::Avatar.image(user.username, "300x300", "jpg")
  json.location user.location.to_s
end