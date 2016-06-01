require "rails_helper"

describe User do
  it { should have_many(:invites_by_other).class_name("Invite").with_foreign_key("invitee_id").order("updated_at desc, status asc") }

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

  describe "#generate_access_token" do
    it "generate random token" do
      user = create :user
      user.generate_access_token("device_id")

      user.reload
      token = user.user_token.where(device_id: "device_id").first

      expect(token.token).not_to eq nil
      expect(token.device_id).to eq "device_id"
    end
  end

  describe "#generate_channel_group" do
    it "generate channel group" do
      user = create :user
      user.generate_channel_group

      user.reload

      expect(user.channel_group).to be_present
    end

    context "not empty" do
      it "doesn't change anything" do
        user = create :user, channel_group: "abcde"

        expect do
          user.generate_channel_group
        end.not_to change(user, :channel_group)
      end
    end
  end
end
