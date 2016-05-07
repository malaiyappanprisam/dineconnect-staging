json.users @users do |user|
  json.id user.id
  json.email user.email
  json.username user.username
  json.first_name user.first_name
  json.last_name user.last_name
  json.gender user.gender
  json.date_of_birth user.date_of_birth
  json.age user.age
  json.profession user.profession
end
