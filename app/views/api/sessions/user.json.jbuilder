json.user do 
  json.id @user.id
  json.token @token.token
  json.email @user.email
  json.username @user.username
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.gender @user.gender
  json.date_of_birth @user.date_of_birth
  json.age @user.age
  json.profession @user.profession
  json.avatar_url @user.avatar_id ? attachment_url(@user, :avatar, :fill, 300, 300, format: "png") : "https://api.adorable.io/avatars/300/#{user.id}.png"
  json.location @user.location
end
