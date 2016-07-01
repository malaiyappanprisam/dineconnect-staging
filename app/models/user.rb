class User < ActiveRecord::Base
  include Clearance::User

  attachment :avatar

  acts_as_voter

  acts_as_taggable_on :interested_ins
  acts_as_taggable_on :favorite_foods
  has_many :user_token, dependent: :destroy
  has_many :invites_by_other, -> { order("updated_at desc, status asc") }, class_name: "Invite", foreign_key: :invitee_id, dependent: :destroy
  has_many :invites_by_me, -> { order("updated_at desc, status asc") }, class_name: "Invite", foreign_key: :user_id, dependent: :destroy
  has_many :photos, as: :photoable

  accepts_attachments_for :photos, attachment: :file, append: true

  enum gender: [:male, :female]
  enum residence_status: [:local, :expat, :out_of_town]
  enum interested_to_meet: [:both_male_and_female, :only_male, :only_female]
  enum payment_preference: [:anything_goes, :paying, :not_paying, :split_bill]

  after_create :generate_channel_group

  def self.favorited_on(restaurants, limit = 6)
    users = []
    favorited_user_ids = restaurants.map do |restaurant|
      restaurant.find_votes_for.limit(limit).pluck(:voter_id)
    end.flatten
    if !favorited_user_ids.empty?
      users = User.where(id: favorited_user_ids)
    end
    users
  end

  def age
    if date_of_birth
      ((Date.today - date_of_birth) / 365).to_i
    else
      0
    end
  end

  def humanize_nationality
    Nationality.list[self.nationality]
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

  def explore_people(payment_preference: :anything_goes,
                     interested_in: :both_male_and_female,
                     age_from: 1, age_to: 100)
    age_range = age_to.years.ago.to_date..age_from.years.ago.to_date
    User.where.not(id: self.id)
      .where(payment_preference: User.payment_preferences[payment_preference.to_sym])
      .where(gender: interested_in_preferences(interested_in))
      .where(date_of_birth: age_range)
      .order(created_at: :desc)
  end

  def update_password_with_confirmation(password_params)
    if password_params[:password] != password_params[:password_confirmation]
      errors.add(:base, "password not match")
      false
    else
      update_password(password_params[:password])
    end
  end

  private
  def interested_in_preferences(preference)
    user_gender_preferences(preference)
  end

  def gender_preferences
    user_gender_preferences(self.interested_to_meet)
  end

  def user_gender_preferences(preference)
    if preference.to_sym == :both_male_and_female
      [ User.genders[:male], User.genders[:female] ]
    elsif preference.to_sym == :only_male
      [ User.genders[:male] ]
    elsif preference.to_sym == :only_female
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
