require "rails_helper"

describe User do
  it { should have_many(:user_token).dependent(:destroy) }
  it do
    should have_many(:invites_by_other)
      .class_name("Invite")
      .with_foreign_key("invitee_id")
      .order("created_at desc, status asc")
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

  it "accepts location" do
    user = User.new(location: "-6.214432, 106.813197")
    expect(user.location_original).to eq("POINT (106.813197 -6.214432)")
    expect(user.location).to eq("-6.214432, 106.813197")
    expect(user.lat).to eq("-6.214432")
    expect(user.long).to eq("106.813197")
  end

  it "accepts latitude longitude" do
    user = User.new(latitude: "-6.214432", longitude: "106.813197")
    expect(user.location_original).to eq("POINT (106.813197 -6.214432)")
    expect(user.location).to eq("-6.214432, 106.813197")
    expect(user.lat).to eq("-6.214432")
    expect(user.long).to eq("106.813197")
  end

  describe "validations" do
    it "reject user below age 18" do
      user = build(:user, date_of_birth: 17.years.ago)
      expect(user).to_not be_valid
    end
  end

  describe "before_save" do
    it "combine first and last name to full name" do
      user = build :user
      user.first_name = "first"
      user.last_name = "last"

      user.save

      expect(user.full_name).to eq("first last")
    end

    it "removes all associations when inactive" do
      user = create :user
      other_user = create :user
      restaurant = create :restaurant
      user.generate_access_token("abcde")
      Invite.create!(user: user, invitee: other_user)
      restaurant.liked_by(user)

      user.update(active: true)

      expect(UserToken.count).to eq 1
      expect(Invite.count).to eq 1
      expect(restaurant.reload.find_votes_for.size).to eq 1

      user.update(active: false)

      expect(UserToken.count).to eq 0
      expect(Invite.count).to eq 0
      expect(restaurant.reload.find_votes_for.size).to eq 0
    end
  end

  describe "after_create" do
    it "generate channel_group" do
      user = build :user

      user.save
      expect(user.reload.channel_group).to be_present
    end
  end

  describe "scope" do
    describe "#general" do
      it "returns only active users" do
        active_user = create :user, active: true
        inactive_user = create :user, active: false
        admin_user = create :user, active: true, role: :admin

        expect(User.general).to include(active_user)
        expect(User.general).not_to include(inactive_user)
        expect(User.general).not_to include(admin_user)
      end
    end

    describe "#nearby" do
      let!(:user) { create :user, location: "-6.214432, 106.813197" }
      it "returns nearby restaurant" do
        nearby_user = User.nearby("-6.214432", "106.813198")

        expect(nearby_user).to include(user)
      end
    end
  end

  describe ".create_from_fb_response" do
    let(:fb_response) { { "id" => "abcdefghijklmno", "gender" => "male" } }
    let(:email) { "tito@pandubrahmanto.com" }
    let(:birthday) { Date.parse("1989-05-04") }
    let(:avatar) { Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png") }
    let(:avatar_url) { "" }
    it "create from fb response" do
      user = User.create_from_fb_response(fb_response, email, birthday, avatar, avatar_url)

      expect(user).to be_valid
      expect(user.uid).to eq("abcdefghijklmno")
      expect(user.gender).to eq("male")
      expect(user.interested_to_meet).to eq("only_female")
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

  describe "#confirm_email" do
    it "sets email_confirmed_at value" do
      user = create(
        :user,
        email_confirmation_token: "token",
        email_confirmed_at: nil,
      )

      user.confirm_email

      expect(user.email_confirmed_at).to be_present
    end
  end

  describe "#chatrooms" do
    it "returns all accepted invitation for logged in user" do
      user = create :user
      invite_1 = create :invite, :accepted, user: user
      invite_2 = create :invite, :accepted, invitee: user
      invite_2_mirror = Invite.where(user: invite_2.invitee, invitee: invite_2.user).first
      invite_3 = create :invite, invitee: user, status: :pending
      invite_4 = create :invite, :accepted, invitee: user
      invite_4_mirror = Invite.where(user: invite_4.invitee, invitee: invite_4.user).first
      invite_4_mirror.update!(status: :block)

      expect(user.reload.chatrooms).to include(invite_1)
      expect(user.reload.chatrooms).to include(invite_2_mirror)
      expect(user.reload.chatrooms).not_to include(invite_3)
      expect(user.reload.chatrooms).to include(invite_4_mirror)
    end
  end

  describe "#recommended_restaurants" do
    let!(:restaurant_rendang) { create :restaurant, known_for_list: "rendang" }
    let!(:user_like_rendang) { create :user, favorite_food_list: "rendang" }

    it "returns restaurants with known_fors match user favorite_foods" do
      expect(user_like_rendang.recommended_restaurants).to include(restaurant_rendang)
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

    context "with payment_preference" do
      let!(:anything_goes) { create :user, payment_preference: :anything_goes }
      let!(:paying) { create :user, payment_preference: :paying }
      let!(:not_paying) { create :user, payment_preference: :not_paying }
      let!(:split_bill) { create :user, payment_preference: :split_bill }
      it "returns user with specified payment preference" do
        expect(user.explore_people(payment_preference: :anything_goes)).to include(anything_goes)
        expect(user.explore_people(payment_preference: :anything_goes)).to include(paying)
        expect(user.explore_people(payment_preference: :anything_goes)).to include(not_paying)
        expect(user.explore_people(payment_preference: :anything_goes)).to include(split_bill)

        expect(user.explore_people(payment_preference: :paying)).to include(anything_goes)
        expect(user.explore_people(payment_preference: :paying)).to include(paying)
        expect(user.explore_people(payment_preference: :paying)).to include(not_paying)
        expect(user.explore_people(payment_preference: :paying)).to include(split_bill)

        expect(user.explore_people(payment_preference: :not_paying)).to include(anything_goes)
        expect(user.explore_people(payment_preference: :not_paying)).to include(paying)
        expect(user.explore_people(payment_preference: :not_paying)).to_not include(not_paying)
        expect(user.explore_people(payment_preference: :not_paying)).to_not include(split_bill)

        expect(user.explore_people(payment_preference: :split_bill)).to include(anything_goes)
        expect(user.explore_people(payment_preference: :split_bill)).to include(paying)
        expect(user.explore_people(payment_preference: :split_bill)).to_not include(not_paying)
        expect(user.explore_people(payment_preference: :split_bill)).to include(split_bill)
      end
    end

    context "with interested in" do
      let!(:male) { create :user, gender: :male }
      let!(:female) { create :user, gender: :female }

      it "returns user with specified interested in" do
        expect(user.explore_people(interested_in: :both_male_and_female)).to include(male)
        expect(user.explore_people(interested_in: :both_male_and_female)).to include(female)

        expect(user.explore_people(interested_in: :only_male)).to include(male)
        expect(user.explore_people(interested_in: :only_male)).to_not include(female)

        expect(user.explore_people(interested_in: :only_female)).to_not include(male)
        expect(user.explore_people(interested_in: :only_female)).to include(female)
      end
    end

    context "with age range" do
      let(:age_18_24) { create :user, date_of_birth: 19.years.ago }
      let(:age_25_30) { create :user, date_of_birth: 27.years.ago }
      let(:age_31_35) { create :user, date_of_birth: 32.years.ago }
      let(:age_35_above) { create :user, date_of_birth: 36.years.ago }

      it "returns user with specified age range" do
        expect(user.explore_people).to include(age_18_24)
        expect(user.explore_people).to include(age_25_30)
        expect(user.explore_people).to include(age_31_35)
        expect(user.explore_people).to include(age_35_above)

        expect(user.explore_people(age_from: 18, age_to: 25)).to include(age_18_24)
        expect(user.explore_people(age_from: 18, age_to: 25)).not_to include(age_25_30)
        expect(user.explore_people(age_from: 18, age_to: 25)).not_to include(age_31_35)
        expect(user.explore_people(age_from: 18, age_to: 25)).not_to include(age_35_above)

        expect(user.explore_people(age_from: 25, age_to: 31)).not_to include(age_18_24)
        expect(user.explore_people(age_from: 25, age_to: 31)).to include(age_25_30)
        expect(user.explore_people(age_from: 25, age_to: 31)).not_to include(age_31_35)
        expect(user.explore_people(age_from: 25, age_to: 31)).not_to include(age_35_above)

        expect(user.explore_people(age_from: 31, age_to: 35)).not_to include(age_18_24)
        expect(user.explore_people(age_from: 31, age_to: 35)).not_to include(age_25_30)
        expect(user.explore_people(age_from: 31, age_to: 35)).to include(age_31_35)
        expect(user.explore_people(age_from: 31, age_to: 35)).not_to include(age_35_above)

        expect(user.explore_people(age_from: 35, age_to: 99)).not_to include(age_18_24)
        expect(user.explore_people(age_from: 35, age_to: 99)).not_to include(age_25_30)
        expect(user.explore_people(age_from: 35, age_to: 99)).not_to include(age_31_35)
        expect(user.explore_people(age_from: 35, age_to: 99)).to include(age_35_above)
      end

      context "with string age" do
        it "doesn't error" do
          expect(user.explore_people(age_from: "35", age_to: "99")).to include(age_35_above)
        end
      end
    end

    context "interest" do
      let!(:sushi_guy) { create :user, interested_in_list: "sushi, rendang" }

      it "returns user with specified interested in" do
        expect(user.explore_people(interest: "ushi")).to include(sushi_guy)
      end
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

  describe "#validated_with_facebook" do
    let(:user) { create :user, uid: uid }

    context "with uid" do
      let(:uid) { "somerandomuidfromfacebook" }
      it "returns true" do
        expect(user.validated_with_facebook).to be_truthy
      end
    end

    context "without uid" do
      let(:uid) { nil }
      it "returns true" do
        expect(user.validated_with_facebook).to be_falsey
      end
    end
  end
end
