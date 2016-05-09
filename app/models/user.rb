class User < ActiveRecord::Base
  include Clearance::User

  has_many :user_token

  enum gender: [:male, :female]
  enum residence_status: [:local, :expat]
  enum interested_to_meet: [:both_male_and_female, :only_male, :only_female]
  enum payment_preference: [:anything_goes, :paying, :not_paying, :split_bill]

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
    self.user_token.build(device_id: device_id, 
                          token: Clearance::Token.new )
  end

  def access_token(device_id)
    self.user_token.where(device_id: device_id).first
  end
end
