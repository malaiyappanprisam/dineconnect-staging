require 'rails_helper'

RSpec.describe UserToken, type: :model do
  it "user_id and device should be unique" do
    user = create :user
    user.user_token.build(device_id: "abc")
    user.save!

    user.user_token.build(device_id: "abc")
    expect(user.valid?).to eq false
  end
end
