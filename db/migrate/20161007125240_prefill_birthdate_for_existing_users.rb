class PrefillBirthdateForExistingUsers < ActiveRecord::Migration
  def up
    User.where(date_of_birth: nil).each do |user|
      user.update(date_of_birth: 18.years.ago)
    end
  end
end
