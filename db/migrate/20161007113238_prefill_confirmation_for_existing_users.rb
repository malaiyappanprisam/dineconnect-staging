class PrefillConfirmationForExistingUsers < ActiveRecord::Migration
  def up
    User.where(active: true).where(email_confirmed_at: nil).each do |user|
      user.confirm_email
    end
  end
end
