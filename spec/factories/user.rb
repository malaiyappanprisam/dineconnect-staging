FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end

    password "qwerty12345"
  end
end
