# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

20.times do
  User.create!(
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      username: Faker::Internet.user_name,
      email: Faker::Internet.safe_email,
      password: Faker::Internet.password,
      gender: User.genders[User.genders.keys.sample],
      date_of_birth: Faker::Date.between(30.year.ago, 25.year.ago),
      profession: Faker::Company.profession
    }
  )
  Restaurant.create!(
    {
      name: Faker::Company.name,
      address: Faker::Address.street_address
    }
  )
end
