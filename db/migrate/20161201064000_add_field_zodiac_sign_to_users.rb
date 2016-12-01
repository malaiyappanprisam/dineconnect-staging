class AddFieldZodiacSignToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zodiac_sign, :string
    users = User.where("date_of_birth is not null")
    users.each do |user|
      user.zodiac_sign = ["aries", "taurus", "gemini", "cancer", "leo", "virgo", "libro", "scorpio", "sagittarius", "capricorn", "aquarius", "pisces"].sample	
      user.save
    end
  end
end
