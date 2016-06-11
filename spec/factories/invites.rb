FactoryGirl.define do
  factory :invite do
    user
    association :invitee, factory: :user
    channel "MyString"
  end
end
