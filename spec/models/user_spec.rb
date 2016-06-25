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
  it { should have_many(:photos) }

  it "accepts interested_in" do
    user = User.new(interested_in_list: "western, pasta")
    expect(user.interested_in_list).to include("western")
    expect(user.interested_in_list).to include("pasta")
  end

  it "accepts favorite_food" do
    user = User.new(favorite_food_list: "pizza, pasta")
    expect(user.favorite_food_list).to include("pizza")
    expect(user.favorite_food_list).to include("pasta")
  end

  describe "after_create" do
    it "generate channel_group" do
      user = build :user

      user.save
      expect(user.reload.channel_group).to be_present
    end
  end

  describe ".favorited_on" do
    let(:user_1) { create :user }
    let(:user_2) { create :user }
    let(:user_3) { create :user }
    let(:restaurant) { create :restaurant }
    subject { User.favorited_on([restaurant]) }
    it "returns list of users that favorited on restaurant by limit" do
      restaurant.liked_by user_1
      restaurant.liked_by user_2

      expect(subject).to include(user_1)
      expect(subject).to include(user_2)
      expect(subject).not_to include(user_3)
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

  describe "#recommended_users" do
    let!(:male_user_in_both) { create :user, gender: :male, interested_to_meet: :both_male_and_female }
    let!(:male_user_in_male) { create :user, gender: :male, interested_to_meet: :only_male }
    let!(:male_user_in_female) { create :user, gender: :male, interested_to_meet: :only_female }
    let!(:female_user_in_both) { create :user, gender: :female, interested_to_meet: :both_male_and_female }
    let!(:female_user_in_male) { create :user, gender: :female, interested_to_meet: :only_male }
    let!(:female_user_in_female) { create :user, gender: :female, interested_to_meet: :only_female }

    context "user male, interested in both" do
      let!(:user) { create :user, gender: :male, interested_to_meet: :both_male_and_female }

      it "returns recommended users list except user itself" do
        expect(user.recommended_users).to include(male_user_in_both)
        expect(user.recommended_users).to include(male_user_in_male)
        expect(user.recommended_users).to_not include(male_user_in_female)
        expect(user.recommended_users).to include(female_user_in_both)
        expect(user.recommended_users).to include(female_user_in_male)
        expect(user.recommended_users).to_not include(female_user_in_female)
      end
    end

    context "user male, interested in male" do
      let!(:user) { create :user, gender: :male, interested_to_meet: :only_male }

      it "returns recommended users list except user itself" do
        expect(user.recommended_users).to include(male_user_in_both)
        expect(user.recommended_users).to include(male_user_in_male)
        expect(user.recommended_users).to_not include(male_user_in_female)
        expect(user.recommended_users).to_not include(female_user_in_both)
        expect(user.recommended_users).to_not include(female_user_in_male)
        expect(user.recommended_users).to_not include(female_user_in_female)
      end
    end

    context "user male, interested in female" do
      let!(:user) { create :user, gender: :male, interested_to_meet: :only_female }

      it "returns recommended users list except user itself" do
        expect(user.recommended_users).to_not include(male_user_in_both)
        expect(user.recommended_users).to_not include(male_user_in_male)
        expect(user.recommended_users).to_not include(male_user_in_female)
        expect(user.recommended_users).to include(female_user_in_both)
        expect(user.recommended_users).to include(female_user_in_male)
        expect(user.recommended_users).to_not include(female_user_in_female)
      end
    end

    context "user female, interested in both" do
      let!(:user) { create :user, gender: :female, interested_to_meet: :both_male_and_female }

      it "returns recommended users list except user itself" do
        expect(user.recommended_users).to include(male_user_in_both)
        expect(user.recommended_users).to_not include(male_user_in_male)
        expect(user.recommended_users).to include(male_user_in_female)
        expect(user.recommended_users).to include(female_user_in_both)
        expect(user.recommended_users).to_not include(female_user_in_male)
        expect(user.recommended_users).to include(female_user_in_female)
      end
    end

    context "user female, interested in male" do
      let!(:user) { create :user, gender: :female, interested_to_meet: :only_male }

      it "returns recommended users list except user itself" do
        expect(user.recommended_users).to include(male_user_in_both)
        expect(user.recommended_users).to_not include(male_user_in_male)
        expect(user.recommended_users).to include(male_user_in_female)
        expect(user.recommended_users).to_not include(female_user_in_both)
        expect(user.recommended_users).to_not include(female_user_in_male)
        expect(user.recommended_users).to_not include(female_user_in_female)
      end
    end

    context "user female, interested in female" do
      let!(:user) { create :user, gender: :female, interested_to_meet: :only_female }

      it "returns recommended users list except user itself" do
        expect(user.recommended_users).to_not include(male_user_in_both)
        expect(user.recommended_users).to_not include(male_user_in_male)
        expect(user.recommended_users).to_not include(male_user_in_female)
        expect(user.recommended_users).to include(female_user_in_both)
        expect(user.recommended_users).to_not include(female_user_in_male)
        expect(user.recommended_users).to include(female_user_in_female)
      end
    end
  end

  describe "#explore_people" do
    let!(:user) { create :user }
    let!(:users) { create_list :user, 2 }
    it "returns users except current_user" do
      expect(user.explore_people).to include(users.first)
      expect(user.explore_people).to include(users.second)
      expect(user.explore_people).to_not include(user)
    end
  end

  describe "#update_password_with_confirmation" do
    let(:user) { create :user }

    it "errors if confirmation not same as password" do
      password_params = {
        password: "mypassword1234",
        password_confirmation: "mypassword12345"
      }
      user.update_password_with_confirmation(password_params)
      expect(user.errors[:base]).to include("password not match")
    end

    it "change password if its right" do
      password_params = {
        password: "mypassword1234",
        password_confirmation: "mypassword1234"
      }
      expect do
        user.update_password_with_confirmation(password_params)
      end.to change(user, :encrypted_password)
    end
  end
end
