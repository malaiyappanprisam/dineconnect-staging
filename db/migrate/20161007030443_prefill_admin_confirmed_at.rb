class PrefillAdminConfirmedAt < ActiveRecord::Migration
  def up
    User.where(active: true).where("role = ?", User.roles[:admin]).each do |user|
      user.confirm_email
    end
  end

  def down
  end
end
