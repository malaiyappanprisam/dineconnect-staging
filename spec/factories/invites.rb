FactoryGirl.define do
  factory :invite do
    user
    association :invitee, factory: :user
    channel "MyString"
    status :pending

    trait :accepted do
      after(:create) do |instance|
        instance.update!(status: :accept)
      end
    end
  end
end
