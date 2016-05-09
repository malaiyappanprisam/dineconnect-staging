require "rails_helper"

describe User do
  describe "#age" do
    before do
      Timecop.freeze(Date.parse("2016-05-07"))
    end

    after do
      Timecop.return
    end

    let(:user) { build :user, date_of_birth: Date.parse("1989-04-05") }

    it "calculate year between DOB to now" do
      expect(user.age).to eq(27)
    end

    context "DOB is nil" do
      let(:user) { build :user, date_of_birth: nil }

      it "returns 0" do
        expect(user.age).to eq(0)
      end
    end
  end

  describe "#generate_user_token" do
    it "generate random token" do
      user = create :user
      user.generate_access_token!("device_id")

      user.reload
      token = user.user_token.where("device_id = 'device_id'").first

      expect(token.token).not_to eq nil
      expect(token.device_id).to eq "device_id"
    end

  end
end
