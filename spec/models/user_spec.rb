require "rails_helper"

describe User do
  it { should have_many(:user_token).dependent(:destroy) }
  it do
    should have_many(:invites_by_other)
      .class_name("Invite")
      .with_foreign_key("invitee_id")
      .order("updated_at desc, status asc")
      .dependent(:destroy)
  end
  it do
    should have_many(:invites_by_me)
      .class_name("Invite")
      .with_foreign_key("user_id")
      .order("updated_at desc, status asc")
      .dependent(:destroy)
  end

  describe "after_create" do
    it "generate channel_group" do
      user = build :user

      user.save
      expect(user.reload.channel_group).to be_present
    end
  end

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

  describe "#chatrooms" do
    it "returns all accepted invitation for logged in user" do
      user = create :user
      invite_1 = create :invite, user: user, status: :accept
      invite_2 = create :invite, invitee: user, status: :accept
      invite_3 = create :invite, invitee: user, status: :pending

      expect(user.reload.chatrooms).to include(invite_1)
      expect(user.reload.chatrooms).to include(invite_2)
      expect(user.reload.chatrooms).not_to include(invite_3)
    end
  end
end
