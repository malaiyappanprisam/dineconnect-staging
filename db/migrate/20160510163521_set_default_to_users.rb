class SetDefaultToUsers < ActiveRecord::Migration
  def up
    User.where(residence_status: nil).update_all(residence_status: 0)
    User.where(interested_to_meet: nil).update_all(interested_to_meet: 0)
    User.where(payment_preference: nil).update_all(payment_preference: 0)
  end

  def down
  end
end
