class User < ActiveRecord::Base
  include Clearance::User

  attachment :avatar

  acts_as_taggable_on :interested_ins
  has_many :user_token, dependent: :destroy
  has_many :invites_by_other, -> { order("updated_at desc, status asc") }, class_name: "Invite", foreign_key: :invitee_id, dependent: :destroy
  has_many :invites_by_me, -> { order("updated_at desc, status asc") }, class_name: "Invite", foreign_key: :user_id, dependent: :destroy

  enum gender: [:male, :female]
  enum residence_status: [:local, :expat]
  enum interested_to_meet: [:both_male_and_female, :only_male, :only_female]
  enum payment_preference: [:anything_goes, :paying, :not_paying, :split_bill]

  after_create :generate_channel_group

  def age
    if date_of_birth
      ((Date.today - date_of_birth) / 365).to_i
    else
      0
    end
  end

  def humanize_nationality
    Nationality.list[nationality]
  end

  def generate_access_token(device_id)
    self.user_token.create(device_id: device_id,
                           token: Clearance::Token.new)
  end

  def generate_channel_group
    return channel_group if channel_group.present?

    update!(channel_group: "#{id}_#{Clearance::Token.new[0..5]}")
  end

  def access_token(device_id)
    self.user_token.where(device_id: device_id).first
  end

  def chatrooms
    Invite.where("user_id = ? OR invitee_id = ?", self.id, self.id)
      .where("status = ?", Invite.statuses[:accept])
  end

  def recommended_users
    User.where.not(id: self.id)
      .where(gender: gender_preferences)
      .where(interested_to_meet: interested_to_meet_preferences)
      .order(created_at: :desc)
  end

  def explore_people
    User.where.not(id: self.id)
      .order(created_at: :desc)
  end

  private
  def gender_preferences
    if self.both_male_and_female?
      [ User.genders[:male], User.genders[:female] ]
    elsif self.only_male?
      [ User.genders[:male] ]
    elsif self.only_female?
      [ User.genders[:female] ]
    else
      []
    end
  end

  def interested_to_meet_preferences
    if self.male?
      [
        User.interested_to_meets[:both_male_and_female],
        User.interested_to_meets[:only_male]
      ]
    elsif self.female?
      [
        User.interested_to_meets[:both_male_and_female],
        User.interested_to_meets[:only_female]
      ]
    else
      []
    end
  end
end
