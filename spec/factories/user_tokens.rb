FactoryGirl.define do
  factory :user_token do
    token "token_for_sign_in"
    user
    device_id "ios-12345"
  end
end
