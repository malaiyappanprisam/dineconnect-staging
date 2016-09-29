FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end

    password "qwerty12345"
    date_of_birth Faker::Date.between(30.year.ago, 25.year.ago)
    active true
    email_confirmed_at Time.current
  end
end
