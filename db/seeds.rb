if User.count < 20
  20.times do
    User.create!(
      {
        email: Faker::Internet.safe_email,
        password: Faker::Internet.password
      }
    )
    Restaurant.create!(
      {
        name: Faker::Company.name,
        address: Faker::Address.street_address,
        area: Faker::Address.city
      }
    )
  end
end

User.all.each do |user|
  user.update(first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              username: Faker::Internet.user_name,
              about_me: Faker::Lorem.paragraph(2),
              location: Faker::Address.street_name,
              gender: User.genders[User.genders.keys.sample],
              date_of_birth: Faker::Date.between(30.year.ago, 25.year.ago),
              profession: Faker::Company.profession,
              nationality: Nationality.list.keys.sample,
              residence_status: User.residence_statuses.values.sample,
              interested_to_meet: User.interested_to_meets.values.sample,
              payment_preference: User.payment_preferences.values.sample)
end

Restaurant.all.each do |restaurant|
  restaurant.update(area: Faker::Address.city,
                    average_cost: Faker::Commerce.price,
                    people_count: Faker::Number.between(1, 3),
                    known_for_list: "#{["western", "chinese"].sample}, #{["chicken", "steak", "fast food"].sample}")
end
