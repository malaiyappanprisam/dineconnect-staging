require 'rails_helper'

describe Invite do
  it { should belong_to(:user) }
  it { should belong_to(:invitee).class_name("User") }
  it { should belong_to(:restaurant) }

  describe "validations" do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:invitee) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:invitee_id) }

    context "status" do
      let(:user) { create :user }
      let(:another_user) { create :user }
      it "should not change from accept to reject" do
        invite = create :invite, user: another_user, invitee: user, status: :accept
        invite.status = "reject"

        expect(invite).not_to be_valid
      end

      it "should not change from reject to accept" do
        invite = create :invite, user: another_user, invitee: user, status: :reject
        invite.status = "accept"

        expect(invite).not_to be_valid
      end
    end
  end

  describe "before create" do
    describe "#fill_channel_group_for_user" do
      let(:user) { create :user, channel_group: channel_group }
      let(:another_user) { create :user }
      context "empty" do
        let(:channel_group) { "" }

        it "fill channel_group to user" do
          invite = build :invite, user: user, invitee: another_user
          invite.save

          expect(user.reload.channel_group).to be_present
        end
      end
    end
  end

  describe "#channel_name" do
    it "returns <user_id>_<invitee_id>" do
      invite = create :invite

      expect(invite.channel_name).to eq("#{invite.user_id}_#{invite.invitee_id}")
    end
  end
end
