class AddFieldZodiacSignToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zodiac_sign, :string
    users = User.where("date_of_birth is not null")
    users.each do |user|
      user.zodiac_sign = Zodiac.where(" ? between to_char(start_date, 'MM-DD') 
                                and to_char(end_date, 'MM-DD')", 
                                self.date_of_birth.strftime("%m-%d")).first.sign	
      user.save
    end
  end
end
