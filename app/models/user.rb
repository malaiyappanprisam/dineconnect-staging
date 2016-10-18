class User < ActiveRecord::Base
  include Clearance::User

  attachment :avatar

  acts_as_voter

  acts_as_taggable_on :interested_ins
  acts_as_taggable_on :favorite_foods
  has_many :user_token, dependent: :destroy
  has_many :invites_by_other, -> { order("created_at desc, status asc") }, class_name: "Invite", foreign_key: :invitee_id, dependent: :destroy
  has_many :invites_by_me, -> { order("updated_at desc, status asc") }, class_name: "Invite", foreign_key: :user_id, dependent: :destroy
  has_many :photos, -> { order(updated_at: :desc) }, as: :photoable

  accepts_attachments_for :photos, attachment: :file, append: true

  enum gender: [:male, :female]
  enum residence_status: [:local, :expat, :out_of_town]
  enum interested_to_meet: [:both_male_and_female, :only_male, :only_female]
  enum payment_preference: [:anything_goes, :paying, :not_paying, :split_bill]
  enum role: [:user, :admin]

  validates_date :date_of_birth, on_or_before: lambda { 18.years.ago },
    on_or_before_message: "must be at least 18 years old"

  scope :general, -> do
    where(active: true).where("role <> ?", User.roles[:admin])
  end

  scope :nearby, -> lat, long, distance = 10_000 do
    sql_select = <<-sql_select
    users.*,
    ST_Distance(ST_GeogFromText('POINT(#{long} #{lat})'), users.location) AS distance
    sql_select
    sql = <<-sql
    ST_Dwithin(users.location::geography,
    ST_GeogFromText('POINT(#{long} #{lat})'), ?)
    sql

    select(sql_select).where(sql, distance).where(active: true).order('distance')
  end

  before_save :delete_all_associations_when_inactive
  before_save :combine_first_and_last_name
  after_create :generate_channel_group

  def self.create_from_fb_response(fb_response, email, birthday, avatar, avatar_url)
    user = User.new
    user.uid = fb_response["id"].to_s
    user.first_name = fb_response["name"].to_s.split(" ").first
    user.last_name = fb_response["name"].to_s.split(" ").second
    user.email = email
    user.gender = fb_response["gender"].to_s
    user.password = SecureRandom.hex(8)
    user.interested_to_meet = if user.gender.to_s == "male"
                                "only_female"
                              else
                                "only_male"
                              end
    user.date_of_birth = birthday
    if avatar_url.present?
      user.remote_avatar_url = avatar_url
    elsif avatar.present?
      user.avatar = avatar
    end
    user.save
    user
  end

  def self.favorited_on(restaurants, limit = 6)
    users = []
    favorited_user_ids = restaurants.map do |restaurant|
      restaurant.find_votes_for.limit(limit).pluck(:voter_id)
    end.flatten
    if !favorited_user_ids.empty?
      users = User.general.where(id: favorited_user_ids)
    end
    users
  end

  def location=(latlong)
    longlat = latlong.to_s.gsub(/\s+/, "").split(",").reverse.join(" ")
    self[:location] = "POINT (#{longlat})"
  end

  def location
    self[:location].to_s.gsub("POINT (", "").gsub(")", "").split(" ").reverse.join(", ")
  end

  def location_original
    self[:location].to_s
  end

  def long
    self[:location].to_s.gsub("POINT (", "").gsub(")", "").split(" ").first
  end

  def lat
    self[:location].to_s.gsub("POINT (", "").gsub(")", "").split(" ").second
  end

  def latitude=(latitude_coordinate)
    longitude_coordinate = long.presence || 0
    self[:location] = "POINT (#{longitude_coordinate} #{latitude_coordinate})"
  end

  def longitude=(longitude_coordinate)
    latitude_coordinate = lat.presence || 0
    self[:location] = "POINT (#{longitude_coordinate} #{latitude_coordinate})"
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

  def confirm_email
    self.email_confirmed_at = Time.current
    save
  end

  def access_token(device_id)
    self.user_token.where(device_id: device_id).first
  end

  def chatrooms
    Invite.where("user_id = ?", self.id)
      .where(status: [Invite.statuses[:accept], Invite.statuses[:block]])
  end

  def recommended_restaurants
    Restaurant.general
      .tagged_with(favorite_food_list.split(","), on: :known_fors)
  end

  def recommended_users
    User.general
      .where.not(id: self.id)
      .where(gender: gender_preferences)
      .where(interested_to_meet: interested_to_meet_preferences)
      .order(created_at: :desc)
  end

  def explore_people(payment_preference: :anything_goes,
                     interested_in: :both_male_and_female,
                     age_from: 1, age_to: 100, interest: nil)
    age_range = age_to.to_i.years.ago.to_date..age_from.to_i.years.ago.to_date
    user = User.general
      .where.not(id: self.id)
      .where(payment_preference: user_payment_preferences(payment_preference))
      .where(gender: interested_in_preferences(interested_in))
      .where(date_of_birth: age_range)
    if interest.present?
      user = user.tagged_with(interest, on: :interested_ins, any: true, wild: true)
    end
    user.order(created_at: :desc)
  end

  def update_password_with_confirmation(password_params)
    if password_params[:password] != password_params[:password_confirmation]
      errors.add(:base, "password not match")
      false
    else
      update_password(password_params[:password])
    end
  end

  def validated_with_facebook
    !!(uid)
  end

  private
  def combine_first_and_last_name
    self.full_name = "#{self.first_name} #{self.last_name}"
  end

  def delete_all_associations_when_inactive
    if active_changed? && self.active == false
      UserToken.where(user: self).destroy_all
      Invite.where("user_id = ? OR invitee_id = ?", self.id, self.id).destroy_all
      ActsAsVotable::Vote.where(voter_id: self.id).destroy_all
    end
  end

  def interested_in_preferences(preference)
    user_gender_preferences(preference)
  end

  def gender_preferences
    user_gender_preferences(self.interested_to_meet)
  end

  def user_payment_preferences(preference)
    if preference.to_sym == :anything_goes || preference.to_sym == :paying
      [
        User.payment_preferences[:anything_goes],
        User.payment_preferences[:paying],
        User.payment_preferences[:not_paying],
        User.payment_preferences[:split_bill]
      ]
    elsif preference.to_sym == :not_paying
      [
        User.payment_preferences[:anything_goes],
        User.payment_preferences[:paying]
      ]
    elsif preference.to_sym == :split_bill
      [
        User.payment_preferences[:anything_goes],
        User.payment_preferences[:paying],
        User.payment_preferences[:split_bill]
      ]
    else
      []
    end
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
